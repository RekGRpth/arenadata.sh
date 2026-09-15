#!/bin/bash -eu
#
# Run the given isolation2 tests together with every test they depend on.
# Analogous to ~/src/isolation2.sh, but the test list is computed from:
#   * the curated DEPS map / deps_for() rules below;
#   * the ordering of the final list is taken from isolation2_schedule;
#   * teardown tests (e.g. gdd/end) are appended at the end.
#
# Usage:
#   ~/src/isolation2-deps.sh [options] TEST [TEST ...]
#
# Options:
#   -n         dry run: only print the computed test list and exit
#   -B         do not prepend the base test(s) ($BASE)
#   -o         turn the `optimizer` GUC on (default: off)
#   -j         enable JIT tuned for tests (default: off)
#   -s FILE    schedule file used for ordering (may be given several times)
#   -x ARG     extra argument passed to pg_isolation2_regress (repeatable)
#
# Examples:
#   ~/src/isolation2-deps.sh gdd/concurrent_update
#   ~/src/isolation2-deps.sh -n segwalrep/dtm_recovery_on_standby

exec 2>&1 &> >(tee "$HOME/isolation2.log")

ISO_DIR="$HOME/gpdb_src/src/test/isolation2"

# ---------------------------------------------------------------------------
# Dependency map:  TEST -> "prereq1 prereq2 ..."  (expanded recursively).
# Name/prefix rules (gdd/*) live in deps_for() below.
#
# isolation2 tests set up and tear down their own state, so a source scan
# (deps_analyze.py) finds almost nothing -- only a few obvious pairs are
# encoded here. Add more by hand as you hit ordering failures.
# ---------------------------------------------------------------------------
declare -A DEPS=(
  [uao_crash_compaction_row]="uao_crash_compaction_column"
  [gdd/end]="gdd/prepare"
  [enable_autovacuum]="disable_autovacuum"
  [idle_gang_cleaner]="enable_autovacuum"
)

# teardown:  TEST -> "test to run at the very end"
declare -A TEARDOWN=()

# Name/prefix rules (used when there is no exact key in DEPS).
deps_for() {
  local t=$1
  if [[ -n ${DEPS[$t]+x} ]]; then
    printf '%s' "${DEPS[$t]}"
    return
  fi
  case $t in
    gdd/prepare|gdd/end) ;;
    gdd/*) printf 'gdd/prepare' ;;
  esac
}
teardown_for() {
  local t=$1
  if [[ -n ${TEARDOWN[$t]+x} ]]; then
    printf '%s' "${TEARDOWN[$t]}"
    return
  fi
  case $t in
    gdd/prepare|gdd/end) ;;
    gdd/*) printf 'gdd/end' ;;
  esac
}

# Tests always prepended to the list (empty by default).
BASE=""

SCHEDULES=(isolation2_schedule)

# ---------------------------------------------------------------------------
DRY=0
S_SET=0
OPTIMIZER=off
JIT=off
EXTRA_ARGS=()
while getopts ":nBojs:x:" opt; do
  case $opt in
    n) DRY=1 ;;
    B) BASE="" ;;
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
REQUESTED=("$@")

cd "$ISO_DIR"

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

# --- teardown tests appended at the end ------------------------------
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

echo "=== Final test list (${#RESULT[@]}): ==="
printf '  %s\n' "${RESULT[@]}"
echo "==="
if [[ $DRY -eq 1 ]]; then
  exit 0
fi

PGOPT="-c optimizer=$OPTIMIZER"
if [[ $JIT == on ]]; then
  PGOPT="$PGOPT -c jit=on -c jit_above_cost=0 -c gp_explain_jit=off"
  if [[ $OPTIMIZER == on ]]; then
    PGOPT="$PGOPT -c optimizer_jit_above_cost=0"
  fi
fi
export PGOPTIONS="$PGOPT"

# There is no `make ... TESTS=` target for isolation2, so invoke the driver
# directly with the same flags the Makefile macro uses (see
# pg_isolation2_regress_installcheck in src/Makefile.global) plus the two
# --init-file / --load-extension options from the `installcheck` recipe.
cmd=(./pg_isolation2_regress
     --inputdir=.
     --init-file=../../../src/test/regress/init_file
     --init-file=./init_file_isolation2
     --load-extension=gp_inject_fault)
if [[ ${#EXTRA_ARGS[@]} -gt 0 ]]; then
  cmd+=("${EXTRA_ARGS[@]}")
fi
cmd+=("${RESULT[@]}")
"${cmd[@]}"
