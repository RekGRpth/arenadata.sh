#!/bin/bash -eux

(
#export PGOPTIONS="-c optimizer=on -c optimizer_enable_table_alias=off"
export PGOPTIONS="-c optimizer=off"
cd "$HOME/src/gpdb$GP_MAJOR/src/test/regress"
make -j$(nproc) clean
make -j$(nproc) install
if [[ "$GP_MAJOR" == "6c" || "$GP_MAJOR" == "6u" ]]; then
    make -j$(nproc) file_monitor
elif [[ "$GP_MAJOR" == "7c" || "$GP_MAJOR" == "7u" ]]; then
    pushd "$HOME/src/gpdb$GP_MAJOR/contrib/spi"
    make -j$(nproc) install
    popd
fi
ln -fs "$HOME/src/gpdb$GP_MAJOR/src/test/regress/regress.so" "$GPHOME/lib/postgresql/regress.so"
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_catalog bfv_olap bfv_statistic bfv_index bfv_partition_plans bfv_aggregate bfv_partition DML_over_joins gporca
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file appendonly
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy with
./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 point polygon circle copy create_misc create_index with rowtypes
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file rowtypes
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file uaocs_compaction/outdatedindex
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file sirv_functions appendonly alter_distpol_dropped vacuum_gp sreh
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file appendonly
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_dropped_cols
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file external_table
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file updatable_views union olap_window_seq
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int4 int8 float8 varchar char text copy union olap_window_seq
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_olap olap_setup olap_window_seq
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file rpt
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_dml_rpt
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file segspace
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file alter_table_ao alter_table_aocs
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file aux_ao_rels_stat
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file expand_table_ao expand_table_aoco
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file expand_table_ao expand_table_aoco alter_table_ao alter_table_aocs
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file explain_analyze
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file scale_factor
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_joins bfv_planner explain_format gp_recursive_cte gporca rpt scale_factor
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file explain_format
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy subselectMY
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file --schedule=./greenplum_schedule.test
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file --schedule=./greenplum_schedule.test2
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file --schedule=./greenplum_schedule.test2
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_correlated_query
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gp_unique_rowid
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file dispatch
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file tablespace
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_functions
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_query_execution
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_bitmapscan
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_olap_windowerr
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_misc_jiras
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_skew
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_subquery
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_joins
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file rpt_tpch
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file rpt
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bb_mpph
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_statistic
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 triggers
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file uao_dml/uao_dml_row uao_dml/uao_dml_column
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gporca
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy plancache
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file not_out_of_shmem_exit_slots
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy create_misc rangefuncs_cdb gp_dqa subselect_gp
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_dml
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gangsize
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gp_unique_rowid
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gporca
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file partition_pruning
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_subquery
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file DML_over_joins
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file alter_db_set_tablespace
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file partition
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gp_query_id
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table copy prepare
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gp_tsrf
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gp_explain
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file update_gp
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_dml gangsize gp_unique_rowid gporca partition_pruning qp_subquery update_gp
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file createdb gp_tablespace_with_faults gp_tablespace temp_tablespaces default_tablespace
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file temp_tablespaces
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file dispatch
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gpcopy
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file copy2
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file functional_deps
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file with_clause
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int4 int8 float8 varchar char text point polygon circle copy create_aggregate create_misc create_index aggregates
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file with
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file with rowtypes
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy bitmapscan bitmapscan_ao join_gp
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 point polygon circle copy create_misc create_index bitmapscan bitmapscan_ao join_gp
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 point polygon circle copy create_misc join_gp
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int4 copy join_gp
#make -j$(nproc) installcheck -i
) 2>&1 | tee "$HOME/regress.log"
