#!/bin/bash -eu
#
# Run the given resource-group isolation2 tests inside the mandatory
# enable/disable bracket. Analogous to ~/src/resgroup.sh, but:
#   * every run is wrapped in the enable ... disable bracket ($BASE / teardown):
#     6.x:  resgroup/enable_resgroup_validate + resgroup/enable_resgroup
#           ... resgroup/disable_resgroup
#     7.x:  resgroup/resgroup_auxiliary_tools_v1
#           ... resgroup/resgroup_disable_resgroup
#     Both sets are listed; whatever doesn't exist on this checkout is dropped;
#   * extra per-test prerequisites come from the DEPS map below;
#   * ordering of the final list is taken from isolation2_resgroup_schedule
#     (6.x) or isolation2_resgroup_v1_schedule (7.x).
#   With -2 (7.x resource group v2 on a cgroup v2 host) the bracket is
#   resgroup/resgroup_auxiliary_tools_v2 ... resgroup/resgroup_disable_resgroup
#   and the order comes from isolation2_resgroup_v2_schedule.
#
# Usage:
#   ~/src/resgroup-deps.sh [options] TEST [TEST ...]
#   (TEST may be given with or without the "resgroup/" prefix)
#
# Options:
#   -n         dry run: only print the computed test list and exit
#   -B         no enable/disable bracket (also skips the teardown)
#   -C         skip the sudo setup: cgroup permissions and, with -2, the
#              IO_LIMIT loop-device tablespaces
#   -2         resource group v2 (cgroup v2): v2 bracket, schedule and setup;
#              with resgroup_io_limit* also checks that the demo datadirs and
#              testtablespace are not on tmpfs/overlayfs (as CI does)
#   -o         turn the `optimizer` GUC on (default: off)
#   -j         enable JIT tuned for tests (default: off)
#   -s FILE    schedule file used for ordering (may be given several times)
#   -x ARG     extra argument passed to pg_isolation2_regress (repeatable)
#
# Environment:
#   STATEMENT_MEM  statement_mem for the run (default: 125MB, as in CI --
#                  ci/scripts/run_resgroup_test.bash for v1 and
#                  concourse/scripts/ic_gpdb_resgroup_v2.bash for v2)
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
    resgroup/resgroup_auxiliary_tools_v*|resgroup/resgroup_disable_resgroup) ;;
    resgroup/*) printf 'resgroup/disable_resgroup resgroup/resgroup_disable_resgroup' ;;
  esac
}

# A test file exists on this checkout (tests generated from input/*.source
# have no sql/*.sql until pg_isolation2_regress runs).
test_exists() {
  [[ -f "sql/$1.sql" || -f "input/$1.source" ]]
}

# ---------------------------------------------------------------------------
DRY=0
S_SET=0
NO_BASE=0
NO_CGROUP=0
RG_VER=1
OPTIMIZER=off
JIT=off
EXTRA_ARGS=()
SCHEDULES=()
while getopts ":nBC2ojs:x:" opt; do
  case $opt in
    n) DRY=1 ;;
    B) NO_BASE=1 ;;
    C) NO_CGROUP=1 ;;
    2) RG_VER=2 ;;
    o) OPTIMIZER=on ;;
    j) JIT=on ;;
    s) if [[ $S_SET -eq 0 ]]; then SCHEDULES=(); S_SET=1; fi
       SCHEDULES+=("$OPTARG") ;;
    x) EXTRA_ARGS+=("$OPTARG") ;;
    *) echo "unknown option: -$OPTARG" >&2; exit 2 ;;
  esac
done
shift $((OPTIND - 1))

# Tests always prepended to the list (disable with -B). Candidates for every
# branch are listed; the ones missing here are silently dropped below.
# Schedule files used to order the final list; missing ones are skipped.
if [[ $RG_VER -eq 2 ]]; then
  BASE="resgroup/resgroup_auxiliary_tools_v2"
  DEFAULT_SCHEDULES=(isolation2_resgroup_v2_schedule)
else
  BASE="resgroup/enable_resgroup_validate resgroup/enable_resgroup resgroup/resgroup_auxiliary_tools_v1"
  DEFAULT_SCHEDULES=(isolation2_resgroup_schedule isolation2_resgroup_v1_schedule)
fi
if [[ $NO_BASE -eq 1 ]]; then
  BASE=""
fi
if [[ $S_SET -eq 0 ]]; then
  SCHEDULES=("${DEFAULT_SCHEDULES[@]}")
fi

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
# The enable bracket always goes first, even if a -s schedule lacks it
# (ties among $BASE tests are broken by their order in $BASE).
for b in $BASE; do
  ORDER_IDX[$b]=-1
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

# Drop prerequisites that don't exist on this checkout (e.g. the 6.x
# enable_resgroup* bracket on 7.x branches and vice versa) -- but keep
# explicitly requested tests as-is so a genuine typo still surfaces as
# pg_isolation2_regress's own error.
FILTERED=()
for t in "${RESULT[@]}"; do
  if test_exists "$t" || [[ -n ${want[$t]+x} ]]; then
    FILTERED+=("$t")
  else
    echo "note: dropping prerequisite not present on this checkout: $t" >&2
  fi
done
RESULT=("${FILTERED[@]}")

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
        if test_exists "$td"; then
          TAIL+=("$td")
        fi
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

# Cleanups registered below run on exit, in order (as in
# concourse/scripts/ic_gpdb_resgroup_v2.bash).
EXIT_HANDLERS=()
run_exit_handlers() {
  local rc=$? h
  for h in "${EXIT_HANDLERS[@]}"; do
    "$h" || true
  done
  return "$rc"
}
trap run_exit_handlers EXIT

# --- IO_LIMIT prerequisites (v2 only) ----------------------------------
# Same as assert_real_filesystem() / setup_loop_devices() in
# concourse/scripts/ic_gpdb_resgroup_v2.bash: IO_LIMIT needs the data
# directories and the test tablespace on a real block device, and
# resgroup_io_limit_alter_in_transaction needs two tablespaces on two
# different ones -- loop-mounted ext4 images under testtablespace/.
DEMO_DATADIRS="$HOME/gpdb_src/gpAux/gpdemo/datadirs"
TESTTABLESPACE="$ISO_DIR/testtablespace"
assert_real_filesystem() {
  local path=$1 fs_type
  mkdir -p "$path"
  fs_type=$(stat -f -c %T "$path")
  if [[ $fs_type == overlayfs || $fs_type == tmpfs ]]; then
    echo "$path is on $fs_type; IO_LIMIT tests require a regular filesystem" >&2
    exit 1
  fi
}
cleanup_loop_devices() {
  local i dir
  for i in 1 2; do
    dir="$TESTTABLESPACE/rg_io_limit_loop_$i"
    if mountpoint -q "$dir"; then
      sudo umount "$dir"
    fi
  done
}
setup_loop_devices() {
  local i dir img src prev=""
  for i in 1 2; do
    dir="$TESTTABLESPACE/rg_io_limit_loop_$i"
    img="$TESTTABLESPACE/io_limit_fs_$i.img"
    mkdir -p "$dir"
    if ! mountpoint -q "$dir"; then
      truncate -s 64M "$img"
      mkfs.ext4 -q -F "$img"
      sudo mount -o loop "$img" "$dir"
    fi
    sudo chown "$usr:$grp" "$dir"
    src=$(findmnt -no SOURCE "$dir" || true)
    if [[ ! -b $src ]]; then
      echo "$dir: mount source '$src' is not a block device node" >&2
      exit 1
    fi
    if [[ $src == "$prev" ]]; then
      echo "both io_limit tablespaces resolved to $src" >&2
      exit 1
    fi
    prev=$src
  done
  EXIT_HANDLERS+=(cleanup_loop_devices)
}

IO_LIMIT=0 IO_LIMIT_LOOP=0
for t in "${RESULT[@]}"; do
  case $t in
    resgroup/resgroup_io_limit_alter_in_transaction) IO_LIMIT=1 IO_LIMIT_LOOP=1 ;;
    resgroup/resgroup_io_limit*) IO_LIMIT=1 ;;
  esac
done
if [[ $RG_VER -eq 2 && $IO_LIMIT -eq 1 ]]; then
  assert_real_filesystem "$DEMO_DATADIRS"
  assert_real_filesystem "$TESTTABLESPACE"
fi

# --- cgroup setup ------------------------------------------------------
# v1: same as ~/src/resgroup.sh.
# v2: same as setup_cgroup_v2() in concourse/scripts/ic_gpdb_resgroup_v2.bash,
#     plus gpdb.service (the default gp_resource_group_cgroup_parent, used
#     until resgroup_auxiliary_tools_v2 switches it to gpdb) as in
#     ~/src/resgroup2.sh; the root cgroup.procs mode is restored on exit.
#     The IO_LIMIT loop devices are set up here too (they need sudo as well).
grp=${GROUP:-$(id -gn)}
usr=${USER:-$(id -un)}
restore_cgroup_procs() {
  sudo chmod "$ORIG_CGROUP_PROCS_MODE" /sys/fs/cgroup/cgroup.procs
}
if [[ $NO_CGROUP -eq 0 && $RG_VER -eq 2 ]]; then
  if [[ ! -f /sys/fs/cgroup/cgroup.controllers ]]; then
    echo "/sys/fs/cgroup is not a cgroup v2 mount (use -C to skip the setup)" >&2
    exit 1
  fi
  sudo mkdir -p /sys/fs/cgroup/gpdb /sys/fs/cgroup/gpdb.service
  echo "+cpuset +io +cpu +memory" | sudo tee /sys/fs/cgroup/cgroup.subtree_control >/dev/null
  sudo chown -R "$usr:$grp" /sys/fs/cgroup/gpdb /sys/fs/cgroup/gpdb.service
  ORIG_CGROUP_PROCS_MODE=$(stat -c %a /sys/fs/cgroup/cgroup.procs)
  sudo chmod a+w /sys/fs/cgroup/cgroup.procs
  EXIT_HANDLERS+=(restore_cgroup_procs)
  if [[ $IO_LIMIT_LOOP -eq 1 ]]; then
    setup_loop_devices
  fi
elif [[ $NO_CGROUP -eq 0 ]]; then
  sudo chmod -R 777 /sys/fs/cgroup/{memory,cpu,cpuset}
  sudo mkdir -p    /sys/fs/cgroup/{memory,cpu,cpuset}/gpdb
  sudo chmod -R 777 /sys/fs/cgroup/{memory,cpu,cpuset}/gpdb
  sudo chown -R "$usr:$grp" /sys/fs/cgroup/{memory,cpu,cpuset}/gpdb
fi

PGOPT="-c optimizer=$OPTIMIZER -c statement_mem=${STATEMENT_MEM:-125MB}"
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
