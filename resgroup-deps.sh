#!/bin/bash -eu
#
# Run the given resource-group isolation2 tests inside the mandatory
# enable/disable bracket. Analogous to ~/src/resgroup.sh, but:
#   * every run is wrapped in  resgroup/enable_resgroup_validate +
#     resgroup/enable_resgroup ... resgroup/disable_resgroup  ($BASE / teardown);
#   * extra per-test prerequisites come from the DEPS map below;
#   * ordering of the final list is taken from isolation2_resgroup_schedule.
#
# Usage:
#   ~/src/resgroup-deps.sh [options] TEST [TEST ...]
#   (TEST may be given with or without the "resgroup/" prefix)
#
# Options:
#   -n         dry run: only print the computed test list and exit
#   -B         no enable/disable bracket (also skips the teardown)
#   -C         skip the sudo cgroup mount/permission setup
#   -o         turn the `optimizer` GUC on (default: off)
#   -j         enable JIT tuned for tests (default: off)
#   -s FILE    schedule file used for ordering (may be given several times)
#   -x ARG     extra argument passed to pg_isolation2_regress (repeatable)
#
# Examples:
#   ~/src/resgroup-deps.sh resgroup_memory_limit
#   ~/src/resgroup-deps.sh -n resgroup/resgroup_cpuset resgroup/resgroup_views

exec 2>&1 &> >(tee "$HOME/resgroup.log")

ISO_DIR="$HOME/gpdb_src/src/test/isolation2"

# ---------------------------------------------------------------------------
# Dependency map:  TEST -> "prereq1 prereq2 ..."  (expanded recursively).
# The enable/disable bracket is handled by $BASE + teardown_for(), not here.
# Add entries as you hit ordering failures between individual resgroup tests.
# ---------------------------------------------------------------------------
declare -A DEPS=(
)

declare -A TEARDOWN=()

deps_for() {
  local t=$1
  if [[ -n ${DEPS[$t]+x} ]]; then
    printf '%s' "${DEPS[$t]}"
  fi
}
teardown_for() {
  local t=$1
  if [[ -n ${TEARDOWN[$t]+x} ]]; then
    printf '%s' "${TEARDOWN[$t]}"
    return
  fi
  case $t in
    resgroup/enable_resgroup|resgroup/enable_resgroup_validate|resgroup/disable_resgroup) ;;
    resgroup/*) printf 'resgroup/disable_resgroup' ;;
  esac
}

# Tests always prepended to the list (disable with -B).
BASE="resgroup/enable_resgroup_validate resgroup/enable_resgroup"

SCHEDULES=(isolation2_resgroup_schedule)

# ---------------------------------------------------------------------------
DRY=0
S_SET=0
NO_CGROUP=0
OPTIMIZER=off
JIT=off
EXTRA_ARGS=()
while getopts ":nBCojs:x:" opt; do
  case $opt in
    n) DRY=1 ;;
    B) BASE="" ;;
    C) NO_CGROUP=1 ;;
    o) OPTIMIZER=on ;;
    j) JIT=on ;;
    s) if [[ $S_SET -eq 0 ]]; then SCHEDULES=(); S_SET=1; fi
       SCHEDULES+=("$OPTARG") ;;
    x) EXTRA_ARGS+=("$OPTARG") ;;
    *) echo "unknown option: -$OPTARG" >&2; exit 2 ;;
  esac
done
shift $((OPTIND - 1))

if [[ $# -eq 0 ]]; then
  echo "specify at least one test" >&2
  exit 2
fi

cd "$ISO_DIR"

# accept bare test names too:  resgroup_views -> resgroup/resgroup_views
REQUESTED=()
for t in "$@"; do
  if [[ $t != */* && -f "sql/resgroup/$t.sql" ]]; then
    t="resgroup/$t"
  fi
  REQUESTED+=("$t")
done

# --- test ordering from the schedule files -------------------------------
declare -A ORDER_IDX=()
idx=0
for f in "${SCHEDULES[@]}"; do
  if [[ ! -f $f ]]; then
    echo "schedule not found, skipping: $f" >&2
    continue
  fi
  while IFS= read -r line; do
    if [[ $line != test:* ]]; then
      continue
    fi
    for tok in ${line#test:}; do
      if [[ -z ${ORDER_IDX[$tok]+x} ]]; then
        ORDER_IDX[$tok]=$idx
        idx=$((idx + 1))
      fi
    done
  done < "$f"
done

# --- requested tests sorted by schedule order ---------------------------
declare -A want=()
for t in "${REQUESTED[@]}"; do
  want[$t]=1
done
ordered_requested=()
while IFS= read -r row; do
  ordered_requested+=("${row#*$'\t'}")
done < <(
  for t in "${!want[@]}"; do
    printf '%s\t%s\n' "${ORDER_IDX[$t]:-999999999}" "$t"
  done | sort -n -k1,1
)

# --- recursive dependency expansion (post-order DFS) -------------------
declare -A SEEN=()
RESULT=()
resolve() {
  local t=$1 d
  if [[ -n ${SEEN[$t]+x} ]]; then
    return
  fi
  SEEN[$t]=1
  for d in $(deps_for "$t"); do
    resolve "$d"
  done
  RESULT+=("$t")
}
if [[ -n $BASE ]]; then
  for b in $BASE; do
    resolve "$b"
  done
fi
for t in "${ordered_requested[@]}"; do
  resolve "$t"
done

# --- final ordering: topological sort (Kahn's algorithm), tie-broken by
# schedule position. DEPS/deps_for() edges are a hard constraint; among
# tests with no ordering constraint between them, the real schedule position
# decides -- instead of a naive per-requested-test DFS append, which can put
# a root test with no known prerequisites way ahead of another requested
# root's whole prerequisite chain just because it was resolved first, even
# though its real schedule position is much later. See regress-deps.sh for
# the concrete case (partition + partial_table) that motivated this.
declare -A POS=()          # DFS position above, used only as a tiebreak
for i in "${!RESULT[@]}"; do
  POS[${RESULT[$i]}]=$i
done
declare -A INCLUDED=()
for t in "${RESULT[@]}"; do
  INCLUDED[$t]=1
done
declare -A REMAIN=() CHILDREN=()
for t in "${RESULT[@]}"; do
  n=0
  for d in $(deps_for "$t"); do
    if [[ -n ${INCLUDED[$d]+x} ]]; then
      n=$((n + 1))
      CHILDREN[$d]="${CHILDREN[$d]:-} $t"
    fi
  done
  REMAIN[$t]=$n
done
TOPO=()
declare -A EMITTED=()
left=${#RESULT[@]}
while [[ $left -gt 0 ]]; do
  best="" best_order=999999999 best_pos=999999999
  for t in "${RESULT[@]}"; do
    if [[ -n ${EMITTED[$t]+x} || ${REMAIN[$t]} -gt 0 ]]; then
      continue
    fi
    o=${ORDER_IDX[$t]:-999999999}
    p=${POS[$t]}
    if [[ -z $best || $o -lt $best_order || ($o -eq $best_order && $p -lt $best_pos) ]]; then
      best=$t; best_order=$o; best_pos=$p
    fi
  done
  if [[ -z $best ]]; then
    echo "internal error: dependency cycle among: ${RESULT[*]}" >&2
    exit 1
  fi
  TOPO+=("$best")
  EMITTED[$best]=1
  left=$((left - 1))
  for c in ${CHILDREN[$best]:-}; do
    REMAIN[$c]=$((REMAIN[$c] - 1))
  done
done
RESULT=("${TOPO[@]}")

# --- teardown (disable_resgroup) appended at the end -------------------
if [[ -n $BASE ]]; then
  declare -A TSEEN=()
  TAIL=()
  for t in "${RESULT[@]}"; do
    for td in $(teardown_for "$t"); do
      if [[ -z ${TSEEN[$td]+x} && -z ${SEEN[$td]+x} ]]; then
        TSEEN[$td]=1
        TAIL+=("$td")
      fi
    done
  done
  if [[ ${#TAIL[@]} -gt 0 ]]; then
    RESULT+=("${TAIL[@]}")
  fi
fi

echo "=== Final test list (${#RESULT[@]}): ==="
printf '  %s\n' "${RESULT[@]}"
echo "==="
if [[ $DRY -eq 1 ]]; then
  exit 0
fi

# --- cgroup setup (same as ~/src/resgroup.sh) -------------------------
if [[ $NO_CGROUP -eq 0 ]]; then
  grp=${GROUP:-$(id -gn)}
  usr=${USER:-$(id -un)}
  sudo chmod -R 777 /sys/fs/cgroup/{memory,cpu,cpuset}
  sudo mkdir -p    /sys/fs/cgroup/{memory,cpu,cpuset}/gpdb
  sudo chmod -R 777 /sys/fs/cgroup/{memory,cpu,cpuset}/gpdb
  sudo chown -R "$usr:$grp" /sys/fs/cgroup/{memory,cpu,cpuset}/gpdb
fi

PGOPT="-c optimizer=$OPTIMIZER"
if [[ $JIT == on ]]; then
  PGOPT="$PGOPT -c jit=on -c jit_above_cost=0 -c gp_explain_jit=off"
  if [[ $OPTIMIZER == on ]]; then
    PGOPT="$PGOPT -c optimizer_jit_above_cost=0"
  fi
fi
export PGOPTIONS="$PGOPT"

cmd=(./pg_isolation2_regress
     --init-file=../../../src/test/regress/init_file
     --init-file=./init_file_resgroup
     --dbname=isolation2resgrouptest
     --load-extension=gp_inject_fault)
if [[ ${#EXTRA_ARGS[@]} -gt 0 ]]; then
  cmd+=("${EXTRA_ARGS[@]}")
fi
cmd+=("${RESULT[@]}")
"${cmd[@]}"
