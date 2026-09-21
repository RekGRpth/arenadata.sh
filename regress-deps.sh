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
#   -o         turn the `optimizer` GUC on (default: off)
#   -j         enable JIT tuned for tests (default: off)
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
  [numerology]="int2 int4 float8"
  [geometry]="point lseg line box path polygon circle"
  [horology]="abstime reltime tinterval"
  [create_type]="create_function_1"
  [create_table]="create_type"
  [create_function_2]="create_table"
  [copy]="create_table"
  [create_misc]="copy"
  [create_operator]="create_function_2 create_misc"
  [create_index]="point polygon circle create_operator"
  [create_view]="int8 create_operator"
  [gp_gin_index]="create_index"
  [inherit]="int4 create_index"
  [triggers]="create_function_1"
  [create_aggregate]="create_misc"
  [create_function_1]="create_function_0"
  [create_function_3]="create_function_1"
  [updatable_views]="copy"
  [errors]="copy"
  [select]="int4 int8 create_index create_misc"
  [select_into]="int8 create_misc"
  [select_distinct]="int4 copy"
  [select_distinct_on]="int4"
  [subselect]="text int4 int8 create_index create_misc"
  [union]="char varchar text int4 int8 float8 copy"
  [join]="text int2 int4 int8 float8 create_index subselect"
  [aggregates]="varchar int4 int8 create_index create_aggregate"
  [portals]="int8 create_index create_misc"
  [arrays]="int8 copy"
  [btree_index]="copy"
  [hash_index]="copy"
  [privileges]="int8"
  [lock]="create_function_1"
  [misc]="create_index create_function_2 create_misc"
  [portals_p2]="create_misc"
  [guc]="tablespace"
  [window]="int4 create_misc"
  [jsonb]="copy json"
  [indirect_toast]="create_function_1"
  [plancache]="int8 copy"
  [plpgsql]="int4 rangetypes plancache"
  [rangefuncs]="int4 int8 rangetypes"
  [prepare]="copy"
  [alter_table]="insert create_index create_table_like"
  [polymorphism]="int8 rangetypes create_misc"
  [rowtypes]="int8 create_index"
  [returning]="int4 int8"
  [with]="aggregates int4 create_aggregate"
  [xml]="copy"
  [gp_aggregates]="copy"
  [shared_scan]="copy"
  [gp_tablespace]="gp_tablespace_with_faults"
  [bitmapscan]="create_function_2"
  [join_gp]="create_index"
  [gpcopy]="plpgsql gpcopy_dispatch"
  [gp_dump_query_oids]="create_view"
  [with_clause]="aggregates create_aggregate"
  [dispatch]="dispatch_encoding"
  [rangefuncs_cdb]="int4 join_gp"
  [subselect_gp]="create_misc create_table_like cursor"
  [olap_window_seq]="create_aggregate"
  [sirv_functions]="with"
  [appendonly]="appendonly_with_gin_index dispatch"
  [create_table_distpol]="copy"
  [query_finish]="query_finish_pending"
  [partition]="create_am partition_join partition_prune partition_aggregate partition_info join_gp copy"
  [partition_ddl]="copy"
  [oid_consistency]="privileges create_table_like"
  [aocs]="dispatch"
  [resource_queue]="rowtypes resource_queue_with_rule"
  [expand_table]="expand_table_regression"
  [bfv_partition]="create_misc bfv_index"
  [gporca]="subselect_gp"
  [aggregate_with_groupingsets]="subselect"
  [bb_mpph]="bfv_partition copy"
  [rpt]="with join_gp subselect"
  [rpt_joins]="create_index subselect"
  [rpt_tpch]="bfv_partition copy"
  [rpt_returning]="with join_gp int8"
  [bfv_joins]="subselect_gp"
  [bfv_dml]="bfv_dml_rpt"
  [qp_misc]="alter_table olap_window_seq qp_misc_rio int4 rowtypes join_gp indexjoin"
  [gp_recursive_cte]="copy"
  [qp_misc_jiras]="alter_table olap_window_seq"
  [qp_with_clause]="with"
  [qp_dropped_cols]="partition_pruning"
  [qp_with_functional_inlining]="privileges bfv_cte"
  [qp_with_functional_noinlining]="privileges bfv_cte"
  [qp_misc_rio]="int4 join_gp indexjoin qp_misc_rio_join_small"
  [qp_correlated_query]="with"
  [qp_functions_in_from]="qp_functions_in_contexts_setup"
  [qp_functions_in_select]="qp_functions_in_contexts_setup"
  [qp_functions_in_subquery]="qp_functions_in_contexts_setup"
  [qp_functions_in_subquery_column]="qp_functions_in_contexts_setup"
  [qp_functions_in_subquery_constant]="qp_functions_in_contexts_setup"
  [qp_functions_in_with]="qp_functions_in_contexts_setup"
  [qp_functions]="triggers qp_functions_in_contexts_setup"
  [uao_compaction/index]="uao_compaction/index_stats"
  [uao_compaction/drop_column]="uao_compaction/drop_column_update"
  [uaocs_compaction/index]="uaocs_compaction/index_stats"
  [uaocs_compaction/drop_column]="uaocs_compaction/drop_column_update"
  [uao_dml/uao_dml_select_row]="qp_correlated_query"
  [uao_dml/uao_dml_select_column]="qp_correlated_query"
  [metadata_track]="qp_targeted_dispatch qp_functions"
  [create_index_spgist]="create_index"
  [create_procedure]="create_misc"
  [index_including]="create_index"
  [index_including_gist]="create_index"
  [multirangetypes]="rangetypes"
  [expressions]="date"
  [insert]="copy"
  [constraints]="create_misc"
  [create_am]="create_index"
  [brin]="create_index"
  [tablesample]="copy"
  [groupingsets]="int8 create_index"
  [brin_bloom]="create_index"
  [brin_multi]="create_index"
  [alter_generic]="create_function_1"
  [misc_functions]="create_index"
  [tsrf]="int8"
  [tidscan]="copy"
  [incremental_sort]="create_index"
  [psql]="create_am"
  [amutils]="create_index_spgist"
  [collate.linux.utf8]="collate.icu.utf8"
  [select_parallel]="int4 create_index misc"
  [write_parallel]="copy"
  [cluster]="copy"
  [tsearch]="create_misc"
  [foreign_data]="create_function_1"
  [equivclass]="copy"
  [limit]="int8 create_index"
  [conversion]="create_function_1"
  [partition_join]="with"
  [partition_prune]="insert"
  [hash_part]="insert"
  [explain]="with"
  [resultcache]="create_index"
  [event_trigger]="inherit"
  [oidjoins]="create_table_like"
  [cluster_gp]="create_misc"
  [decode_expr]="create_misc"
  [sublink]="insert"
  [table_functions]="create_am"
  [distributed_transactions]="alter_table"
  [incremental_analyze]="alter_table"
  [partition_storage]="create_am"
  [brin_ao]="create_index"
  [brin_aocs]="create_index"
  [rle]="create_misc"
  [alter_table_aocs]="create_table_like"
  [alter_table_ao]="create_table_like"
  [uao_dml/uao_dml_cursor_row]="create_misc"
  [uao_dml/uao_dml_cursor_column]="create_misc"
  [gp_upgrade_cornercases]="alter_table"
)

# Tests always prepended to the list (disable with -B). Not every branch has
# this test (e.g. 6.x-based Greengage checkouts have no test_setup at all) --
# it's silently dropped below if sql/test_setup.sql doesn't exist here.
BASE="test_setup"

# Schedule files used to order the final list. Try every naming this repo has
# used across branches; missing ones are skipped with a note below.
SCHEDULES=(parallel_schedule greenplum_schedule greengage_schedule)

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

# Drop prerequisites that don't exist on this checkout (e.g. `test_setup` on
# branches that don't have it) -- but keep explicitly requested tests as-is
# so a genuine typo still surfaces as pg_regress's own "test not found" error.
FILTERED=()
for t in "${RESULT[@]}"; do
  if [[ -f "sql/$t.sql" || -n ${want[$t]+x} ]]; then
    FILTERED+=("$t")
  else
    echo "note: dropping prerequisite not present on this checkout: $t" >&2
  fi
done
RESULT=("${FILTERED[@]}")

# --- final ordering: topological sort (Kahn's algorithm), tie-broken by
# schedule position. DEPS edges are a hard constraint; among tests with no
# ordering constraint between them, the real schedule position decides.
#
# A naive per-requested-test DFS append (the old approach) instead just
# concatenates each requested test's whole dependency subtree in the order
# the tests were requested/schedule-sorted *against each other only* -- so a
# root with no known prerequisites (e.g. partial_table) that happens to sit
# earlier in the schedule than another requested root (e.g. partition) got
# spliced in front of that other root's entire prerequisite chain, even
# though partial_table's real schedule position is much later than
# create_function_1/create_table/etc. `regress-deps.sh partition` alone
# passed; `regress-deps.sh partition partial_table` inverted that order and
# started failing -- this is what fixes it.
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
  for d in ${DEPS[$t]:-}; do
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
