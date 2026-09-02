#!/bin/bash -eu
#
# Run the given regress tests together with every test they depend on.
# Analogous to ~/src/regress.sh, but the test list is computed from:
#   * the curated DEPS map below (extend it as needed);
#   * the ordering of the final list is taken from the schedule files.
#
# Usage:
#   ~/src/regress-deps.sh [options] TEST [TEST ...]
#
# Options:
#   -n         dry run: only print the computed test list and exit
#   -B         do not prepend the base test(s) ($BASE)
#   -o on|off  set the `optimizer` GUC (default: off)
#   -j on|off  enable JIT tuned for tests (default: off)
#   -s FILE    schedule file used for ordering (may be given several times;
#              the first occurrence of a test fixes its position)
#   -x ARG     extra argument passed to pg_regress (may be given several times)
#
# Examples:
#   ~/src/regress-deps.sh brin_bloom
#   ~/src/regress-deps.sh -n privileges
#   ~/src/regress-deps.sh create_index gp_gin_index

exec 2>&1 &> >(tee "$HOME/regress.log")

REGRESS_DIR="$HOME/gpdb_src/src/test/regress"

# ---------------------------------------------------------------------------
# Curated dependency map:  TEST -> "prereq1 prereq2 ..."
# Dependencies are expanded recursively. Extend this as needed.
#
# Mostly derived from the test sources (sql/*.sql) by scratchpad/deps_analyze.py:
# a test depends on another when it reads an object (table, *_TBL fixture,
# view, function, aggregate) that the other test creates. Table data is loaded
# in `copy`, so tests that read tenk1/onek/person/road/... depend on `copy`.
# Regenerate with:  python3 deps_analyze.py -v regress
# ---------------------------------------------------------------------------
declare -A DEPS=(
  # --- core chains (schedule header comments + data-load ordering) ---
  [create_type]="create_function_1"
  [create_table]="create_type"
  [create_function_2]="create_table"
  [create_function_3]="create_function_1"
  [create_cast]="create_function_1"
  [copy]="create_table"
  [copyselect]="copy"
  [copydml]="copy"
  [create_misc]="copy"
  [create_operator]="create_misc"
  [create_procedure]="create_misc"
  [create_aggregate]="create_misc"
  [create_index]="point polygon circle create_operator"
  [create_index_spgist]="create_index"
  [create_view]="int8 create_operator"
  [index_including]="create_index"
  [index_including_gist]="create_index"
  [gp_gin_index]="create_index"
  [strings]="char varchar text"
  [numerology]="int2 int4 int8 float4 float8"
  [multirangetypes]="rangetypes"
  [horology]="interval timetz timestamp timestamptz"
  # --- derived from sources: test reads *_TBL / data created elsewhere ---
  [geometry]="point lseg line box path polygon circle"
  [expressions]="date"
  [select]="create_misc"
  [inherit]="int4 copy"
  [errors]="copy"
  [select_into]="int8 create_misc"
  [select_distinct]="copy"
  [select_distinct_on]="int4"
  [subselect]="text int4 int8 copy"
  [union]="text int4 int8 float8 copy"
  [join]="text int2 int4 int8 copy"
  [aggregates]="int4 int8 copy"
  [portals]="int8 copy"
  [arrays]="copy"
  [btree_index]="copy"
  [hash_index]="copy"
  [brin]="copy"
  [brin_bloom]="copy"
  [brin_multi]="copy"
  [brin_ao]="copy"
  [brin_aocs]="copy"
  [privileges]="int8"
  [tablesample]="copy"
  [groupingsets]="int8 copy"
  [insert]="create_table"
  [insert_conflict]="create_table"
  [constraints]="create_table"
  [triggers]="create_function_1 create_table"
  [vacuum]="create_table"
  [misc]="create_function_2 create_misc"
  [misc_functions]="copy"
  [tsrf]="int8"
  [tidscan]="copy"
  [incremental_sort]="copy"
  [psql]="copy"
  [select_parallel]="int4 copy"
  [write_parallel]="copy"
  [select_views]="create_view"
  [portals_p2]="create_misc"
  [cluster]="copy"
  [window]="int4 copy"
  [equivclass]="copy"
  [jsonb]="copy"
  [plancache]="int8 copy"
  [limit]="int8 copy"
  [plpgsql]="int4 int8 copy"
  [rangefuncs]="int4 int8"
  [prepare]="copy"
  [conversion]="create_function_1"
  [alter_table]="copy"
  [polymorphism]="int8"
  [rowtypes]="int8 copy"
  [returning]="int4 int8"
  [with]="int4 copy"
  [xml]="copy"
  [partition_join]="int8 with"
  [explain]="int8 with"
  [resultcache]="copy"
  # --- GPDB-specific ---
  [gp_aggregates]="copy"
  [gp_explain]="test_setup"
  [gp_array_agg]="test_setup"
  [statement_mem_for_windowagg]="test_setup"
  [qp_union_intersect]="test_setup"
  [eagerfree]="test_setup"
  [join_gp]="copy"
  [subselect_gp]="copy"
  [with_clause]="aggregates"
  [rangefuncs_cdb]="int4 join_gp"
  [rpt_returning]="int8 with join_gp"
  [resource_queue]="copy"
  [ic]="inherit"
  [alter_table_ao]="create_table_like"
  [alter_table_aocs]="create_table_like"
  [oid_consistency]="create_table_like"
  [qp_functions_in_from]="qp_functions_in_contexts_setup"
)

# Tests always prepended to the list (disable with -B).
BASE="test_setup"

# Schedule files used to order the final list.
SCHEDULES=(parallel_schedule greenplum_schedule)

# ---------------------------------------------------------------------------
DRY=0
S_SET=0
OPTIMIZER=off
JIT=off
EXTRA_ARGS=()
while getopts ":nBo:j:s:x:" opt; do
  case $opt in
    n) DRY=1 ;;
    B) BASE="" ;;
    o) OPTIMIZER="$OPTARG" ;;
    j) JIT="$OPTARG" ;;
    s) if [[ $S_SET -eq 0 ]]; then SCHEDULES=(); S_SET=1; fi
       SCHEDULES+=("$OPTARG") ;;
    x) EXTRA_ARGS+=("$OPTARG") ;;
    *) echo "unknown option: -$OPTARG" >&2; exit 2 ;;
  esac
done
shift $((OPTIND - 1))

case $OPTIMIZER in
  on|off) ;;
  *) echo "invalid -o value: $OPTIMIZER (expected on|off)" >&2; exit 2 ;;
esac
case $JIT in
  on|off) ;;
  *) echo "invalid -j value: $JIT (expected on|off)" >&2; exit 2 ;;
esac

if [[ $# -eq 0 ]]; then
  echo "specify at least one test" >&2
  exit 2
fi
REQUESTED=("$@")

cd "$REGRESS_DIR"

# --- test ordering from the schedule files --------------------------------
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

# --- requested tests sorted by schedule order ----------------------------
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

# --- recursive dependency expansion (post-order DFS) ---------------------
declare -A SEEN=()
RESULT=()
resolve() {
  local t=$1 d
  if [[ -n ${SEEN[$t]+x} ]]; then
    return
  fi
  SEEN[$t]=1
  for d in ${DEPS[$t]:-}; do
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

echo "=== Final test list (${#RESULT[@]}): ==="
printf '  %s\n' "${RESULT[@]}"
echo "==="
if [[ $DRY -eq 1 ]]; then
  exit 0
fi

# --- environment setup (same as ~/src/regress.sh) -----------------------
PGOPT="-c optimizer=$OPTIMIZER"
if [[ $JIT == on ]]; then
  PGOPT="$PGOPT -c jit=on -c jit_above_cost=0 -c gp_explain_jit=off"
  if [[ $OPTIMIZER == on ]]; then
    PGOPT="$PGOPT -c optimizer_jit_above_cost=0"
  fi
fi
export PGOPTIONS="$PGOPT"
psql -v ON_ERROR_STOP=0 <<'EOF'
alter database templatedb with is_template=false;
drop database if exists limitdb;
drop database if exists limitdb2;
drop database if exists templatedb;
drop database if exists copieddb;
drop database if exists "limit_evil_'""_db";
drop role if exists connlimit_test_user;
EOF
ln -fs "$REGRESS_DIR/regress.so" "$GPHOME/lib/postgresql/regress.so"
mkdir -p "$REGRESS_DIR/testtablespace_default_tablespace"
mkdir -p "$REGRESS_DIR/testtablespace_database_tablespace"

cmd=(./pg_regress --load-extension=gp_inject_fault --init-file=init_file)
if [[ ${#EXTRA_ARGS[@]} -gt 0 ]]; then
  cmd+=("${EXTRA_ARGS[@]}")
fi
cmd+=("${RESULT[@]}")
"${cmd[@]}"
