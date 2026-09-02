#!/bin/bash -eu
#
# Run the given regress tests together with every test they depend on,
# via the canonical `make installcheck-tests TESTS="..."`.
# The test list is computed from:
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
#   -x ARG     extra pg_regress option, passed via EXTRA_REGRESS_OPTS
#              (may be given several times)
#
# Examples:
#   ~/src/regress-deps.sh brin_bloom
#   ~/src/regress-deps.sh -n privileges
#   ~/src/regress-deps.sh create_index gp_gin_index

exec 2>&1 &> >(tee "$HOME/regress.log")

REGRESS_DIR="$HOME/gpdb_src/src/test/regress"

# ---------------------------------------------------------------------------
# Dependency map:  TEST -> "prereq1 prereq2 ..."  (expanded recursively).
#
# Derived from the test sources (sql/*.sql) by ~/src/deps_analyze.py: a test
# depends on another when its text mentions an object (table, *_TBL / *_heap
# fixture, index, view, function, aggregate) that only the other test creates
# -- including names inside string literals, e.g. brin_summarize('tenk1_unique1').
# Table *data* is loaded in `copy`, so readers of tenk1/onek/... depend on copy.
# A few base chains are seeded by hand. Edges are transitively reduced and
# ordered by schedule.  Regenerate:  python3 ~/src/deps_analyze.py --bash regress
# ---------------------------------------------------------------------------
declare -A DEPS=(
  [multirangetypes]="rangetypes"
  [geometry]="point lseg line box path polygon circle"
  [expressions]="date"
  [create_type]="create_function_1"
  [create_table]="create_type"
  [create_function_2]="create_table"
  [copy]="create_table"
  [insert]="copy"
  [create_misc]="copy"
  [create_operator]="create_function_2 create_misc"
  [create_procedure]="create_misc"
  [create_index]="point polygon circle create_operator"
  [create_index_spgist]="create_index"
  [create_view]="int8 create_operator"
  [index_including]="create_index"
  [index_including_gist]="create_index"
  [gp_gin_index]="create_index"
  [create_aggregate]="create_misc"
  [create_function_3]="create_function_1"
  [triggers]="create_function_1"
  [select]="int4 int8 create_index"
  [inherit]="int4 create_index"
  [updatable_views]="copy"
  [create_am]="create_index"
  [errors]="copy"
  [select_into]="int8 create_misc"
  [select_distinct]="int4 copy"
  [select_distinct_on]="int4"
  [subselect]="text int4 int8 create_index"
  [union]="text int4 int8 float8 copy"
  [join]="text int2 int4 int8 float8 create_index"
  [aggregates]="int4 int8 create_index create_aggregate"
  [portals]="int8 create_index"
  [arrays]="int8 copy"
  [btree_index]="copy"
  [hash_index]="copy"
  [brin]="create_index"
  [privileges]="int8"
  [lock]="create_function_1"
  [tablesample]="copy"
  [groupingsets]="int8 create_index"
  [brin_bloom]="create_index"
  [brin_multi]="create_index"
  [alter_generic]="create_function_1"
  [misc]="create_index"
  [misc_functions]="create_index"
  [tsrf]="int8"
  [tidscan]="copy"
  [incremental_sort]="create_index"
  [psql]="create_am"
  [amutils]="create_index_spgist"
  [collate.linux.utf8]="collate.icu.utf8"
  [select_parallel]="int4 create_index"
  [write_parallel]="copy"
  [portals_p2]="create_misc"
  [cluster]="copy"
  [foreign_data]="create_function_1"
  [window]="int4 copy"
  [indirect_toast]="create_function_1"
  [equivclass]="copy"
  [jsonb]="copy json"
  [plancache]="int8 copy"
  [limit]="int8 create_index"
  [plpgsql]="int4 rangetypes plancache"
  [rangefuncs]="int4 int8 rangetypes"
  [prepare]="copy"
  [conversion]="create_function_1"
  [alter_table]="insert create_index create_table_like"
  [polymorphism]="int8 rangetypes"
  [rowtypes]="int8 create_index"
  [returning]="int4 int8"
  [with]="aggregates"
  [xml]="copy"
  [partition_join]="with"
  [partition_prune]="insert"
  [hash_part]="insert"
  [explain]="with"
  [resultcache]="create_index"
  [event_trigger]="inherit"
  [oidjoins]="create_table_like"
  [gp_aggregates]="copy"
  [gp_tablespace]="gp_tablespace_with_faults"
  [decode_expr]="create_table"
  [bitmapscan]="create_function_2"
  [join_gp]="create_index"
  [gpcopy]="gpcopy_dispatch"
  [distributed_transactions]="alter_table"
  [gp_dump_query_oids]="create_view"
  [incremental_analyze]="alter_table"
  [with_clause]="aggregates"
  [rangefuncs_cdb]="int4 join_gp"
  [subselect_gp]="copy create_table_like"
  [olap_window_seq]="create_aggregate"
  [sirv_functions]="with"
  [create_table_distpol]="copy"
  [partition]="partition_join partition_prune partition_aggregate partition_info join_gp"
  [partition_ddl]="copy"
  [brin_ao]="create_index"
  [brin_aocs]="create_index"
  [alter_table_aocs]="create_table_like"
  [alter_table_ao]="create_table_like"
  [oid_consistency]="privileges create_table_like"
  [resource_queue]="rowtypes"
  [qp_misc_rio]="int4 join_gp indexjoin"
  [dispatch]="dispatch_encoding"
  [bb_mpph]="copy bfv_partition"
  [gporca]="subselect_gp"
  [rpt]="with join_gp"
  [rpt_joins]="create_index"
  [rpt_tpch]="copy bfv_partition"
  [rpt_returning]="with join_gp"
  [qp_misc]="alter_table olap_window_seq qp_misc_rio"
  [gp_recursive_cte]="copy"
  [qp_misc_jiras]="alter_table olap_window_seq"
  [qp_with_clause]="with"
  [qp_with_functional_inlining]="privileges"
  [qp_with_functional_noinlining]="privileges"
  [qp_correlated_query]="with"
  [qp_functions_in_from]="qp_functions_in_contexts_setup"
  [qp_functions_in_select]="qp_functions_in_contexts_setup"
  [qp_functions_in_subquery]="qp_functions_in_contexts_setup"
  [qp_functions_in_subquery_column]="qp_functions_in_contexts_setup"
  [qp_functions_in_with]="qp_functions_in_contexts_setup"
  [qp_functions]="qp_functions_in_contexts_setup"
  [uao_dml/uao_dml_select_row]="qp_correlated_query"
  [uao_dml/uao_dml_select_column]="qp_correlated_query"
  [uao_compaction/drop_column]="uao_compaction/drop_column_update"
  [uaocs_compaction/drop_column]="uaocs_compaction/drop_column_update"
  [gp_upgrade_cornercases]="alter_table"
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

# Canonical entry point: `make installcheck-tests TESTS="..."` supplies
# --init-file / --dlpath / --load-extension=gp_inject_fault itself and
# rebuilds pg_regress as needed.
make_args=(installcheck-tests "TESTS=${RESULT[*]}")
if [[ ${#EXTRA_ARGS[@]} -gt 0 ]]; then
  make_args+=("EXTRA_REGRESS_OPTS=${EXTRA_ARGS[*]}")
fi
make "${make_args[@]}"
