#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/regress.log")

export PGOPTIONS="-c optimizer=off"
#export PGOPTIONS="-c optimizer_enable_table_alias=off"
#export PGOPTIONS="-c optimizer=on -c optimizer_enable_table_alias=off"
#export PGOPTIONS="-c optimizer=on -c jit=on -c jit_above_cost=0 -c optimizer_jit_above_cost=0 -c gp_explain_jit=off"
#export PGOPTIONS="-c optimizer=off -c jit=on -c jit_above_cost=0 -c gp_explain_jit=off"
#cd "$HOME/gpdb_src/src/test/regress"
pushd "$HOME/gpdb_src/src/test/regress"
#make -j$(nproc) clean
#make -j$(nproc) install
#make -j$(nproc) twophase_pqexecparams
#make -j$(nproc) tablespace-setup
#if [[ "$GP_MAJOR" == "6c" || "$GP_MAJOR" == "6u" ]]; then
#    make -j$(nproc) file_monitor
#elif [[ "$GP_MAJOR" == "7c" || "$GP_MAJOR" == "7u" || "$GP_MAJOR" == "8u" ]]; then
#    pushd "$HOME/gpdb_src/contrib/spi"
#    make -j$(nproc) install
#    popd
#fi
#make -j$(nproc) installcheck -i
#exit
ln -fs "$HOME/gpdb_src/src/test/regress/regress.so" "$GPHOME/lib/postgresql/regress.so"
mkdir -p "$HOME/gpdb_src/src/test/regress/testtablespace_default_tablespace"
mkdir -p "$HOME/gpdb_src/src/test/regress/testtablespace_database_tablespace"
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_catalog bfv_olap bfv_statistic bfv_index bfv_partition_plans
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_catalog bfv_olap bfv_statistic bfv_index bfv_partition_plans bfv_aggregate
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_catalog bfv_olap bfv_statistic bfv_index bfv_partition_plans bfv_aggregate bfv_partition table_statistics
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_catalog bfv_olap bfv_statistic bfv_index bfv_partition_plans bfv_aggregate bfv_partition DML_over_joins gporca
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_catalog bfv_olap bfv_statistic bfv_index bfv_partition_plans bfv_aggregate bfv_partition
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_functions_in_contexts_setup qp_functions_in_from
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy privileges
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy tsearch
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy json jsonb
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy json jsonb rangefuncs
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy json jsonb rangefuncs tsearch
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file workfile/hashjoin_spill
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy cluster
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table create_function_2 int8 int4 text point polygon circle copy create_misc create_index brin
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table create_function_2 int8 int4 text point polygon circle copy create_misc create_index create_index_spgist
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy btree_index
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy tidscan
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file orca_static_pruning
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file createdb function_extensions
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy resource_queue
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file enum
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file matfuncscan
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file autovacuum-template0-segment
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file dependency
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file dpe
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_orca_fallback
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file catcache
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gporca bfv_joins
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gporca
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file replication_slots
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file tuplesort
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file direct_dispatch
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file timestamp
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file fts_recovery_in_progress
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file stats_ext
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_dml_joins
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file workfile/spilltodisk
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file olap_setup olap_group
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file select_having
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file functional_deps
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gp_metadata
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file vacuum
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file domain
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file inet
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file zlib
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file box
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 foreign_data
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table create_function_2 int8 int4 text point polygon circle copy create_misc create_index misc select_parallel
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table create_function_2 int8 int4 text point polygon circle copy create_misc create_index
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file generated
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy plpgsql
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy rangefuncs
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file constraints
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table create_function_2 int8 int4 text point polygon circle copy create_misc create_index create_am
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_am brin_interface alter_distribution_policy alter_table_set alter_table_ao alter_table_repack uao_ddl/alter_table_reloptions_row uao_ddl/alter_table_reloptions_column
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file rowsecurity
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gp_partition_template
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file partition_ddl
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file partition_storage
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file partition_indexing
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file appendonly
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy create_misc create_function_2 create_operator create_view
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file timetz
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file namespace
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy with
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 text point polygon circle copy create_misc create_index subselect
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 point polygon circle copy create_misc create_index with rowtypes
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int2 int4 int8 float8 varchar char text point polygon circle copy create_aggregate create_misc create_index index_including subselect union case inherit join
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int2 int4 int8 float8 varchar char text point polygon circle copy create_aggregate create_misc create_index union case inherit join
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int2 int4 int8 float8 varchar char text point polygon circle copy create_aggregate create_misc create_index subselect union case inherit join
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int2 int4 int8 float8 varchar char text point polygon circle copy create_aggregate create_misc create_index index_including
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file rules
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file uaocs_compaction/outdatedindex
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file sirv_functions appendonly alter_distpol_dropped vacuum_gp sreh
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file sirv_functions
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file appendonly
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file disable_autovacuum vacuum_gp
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_dropped_cols
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_targeted_dispatch
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_gist_indexes4
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file external_table
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gp_create_table
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file updatable_views union olap_window_seq
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file updatable_views
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file updatable_views gist
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file updatable_views create_function_1 create_type create_table int8 int4 copy create_misc create_index brin gin gist
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_schema
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file subscription
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int4 int8 float8 varchar char text copy union window qp_with_clause
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int4 int8 float8 varchar char text copy union olap_window_seq
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int4 int8 float8 varchar char text copy olap_setup olap_window_seq
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int4 int8 float8 varchar char text copy union
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_olap olap_setup olap_window_seq
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file psql_gp_commands
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file pg_lsn
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file orca_groupingsets_fallbacks
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file rangetypes
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file pg_resetwal
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file rpt
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_catalog
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file notin
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_joins bfv_planner rpt insert_conflict
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_dml_rpt
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file segspace
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file subselect
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file alter_table_ao alter_table_aocs
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file indexing
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file matview_ao
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file alter_table_set_am
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file partition_locking
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file date expressions
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file python3/plpython_error
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file partition_pruning
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file interval
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file aux_ao_rels_stat
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file expand_table_ao expand_table_aoco
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file expand_table_ao expand_table_aoco alter_table_ao alter_table_aocs
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file explain_analyze
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file analyze incremental_analyze
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gp_copy_dtx distributed_transactions qp_targeted_dispatch gp_query_id analyze incremental_analyze
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gp_copy_dtx distributed_transactions qp_targeted_dispatch gp_query_id analyze
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file scale_factor
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_joins bfv_planner explain_format gp_recursive_cte
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_joins bfv_planner explain_format gp_recursive_cte gporca rpt scale_factor
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file explain_format
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy subselectMY
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file --schedule=./parallel_schedule_my
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file --schedule=./greenplum_schedule.test
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file --schedule=./greenplum_schedule.test2
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file --schedule=./greenplum_schedule.test2
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_correlated_query
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gp_unique_rowid
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file dispatch
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file fts_error
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file collate.icu.utf8
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file collate.linux.utf8
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file horology
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file database
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file tablespace
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_functions
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_query_execution
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_bitmapscan
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_olap_windowerr
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_misc_jiras
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_misc
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_skew
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_subquery
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_joins
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file rpt_tpch
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file rpt
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bb_mpph
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_statistic
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 triggers
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 text point polygon circle copy create_misc create_index create_function_2 create_operator insert
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 text point polygon circle copy create_misc create_index create_function_2 create_operator insert partition_prune
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 text point polygon circle copy create_misc create_index create_function_2 create_operator insert partition_aggregate
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 text point polygon circle copy create_misc create_index create_function_2 create_operator insert partition_join
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 text point polygon circle copy create_misc create_index create_function_2 create_operator insert alter_table
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 text point polygon circle copy create_misc create_index create_function_2 create_operator insert update
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 text point polygon circle copy create_misc create_index create_function_2 create_operator insert partition
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 text point polygon circle copy create_misc create_index inherit
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file uao_dml/uao_dml_row uao_dml/uao_dml_column
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy plancache
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file not_out_of_shmem_exit_slots
./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 triggers create_type create_table int8 int4 copy create_misc rangefuncs_cdb gp_dqa subselect_gp subselect_gp2
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy create_misc rangefuncs_cdb gp_dqa subselect_gp subselect_gp2
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy create_misc create_index brin gin gist spgist privileges init_privs security_label
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy create_misc brin gin gist spgist privileges init_privs security_label collate matview lock replica_identity rowsecurity object_address tablesample groupingsets drop_operator password identity
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy create_misc brin gin gist spgist privileges init_privs security_label collate matview lock replica_identity rowsecurity object_address tablesample groupingsets drop_operator password identity generated join_hash create_table_like alter_generic alter_operator misc select_parallel
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 point polygon circle copy create_misc create_index brin
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 point polygon circle copy create_misc create_index brin gin gist spgist privileges init_privs security_label collate matview lock replica_identity rowsecurity object_address tablesample groupingsets
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 point polygon circle copy create_misc create_index brin gin gist spgist privileges init_privs security_label collate matview lock replica_identity rowsecurity object_address tablesample groupingsets
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy create_misc gin gist spgist privileges init_privs collate matview lock replica_identity rowsecurity object_address tablesample drop_operator password identity generated join_hash
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy create_misc gin gist spgist privileges init_privs collate matview lock replica_identity rowsecurity object_address tablesample drop_operator password identity generated
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy create_misc gin gist spgist privileges init_privs collate matview lock replica_identity rowsecurity object_address tablesample drop_operator password identity
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy create_misc gin gist spgist privileges init_privs collate matview lock replica_identity rowsecurity object_address tablesample drop_operator password
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy create_misc gin gist spgist privileges init_privs collate matview lock replica_identity rowsecurity object_address tablesample
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy create_misc gin gist spgist privileges init_privs collate matview lock replica_identity rowsecurity object_address
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy create_misc gin gist spgist privileges init_privs collate matview lock replica_identity
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy create_misc gin gist spgist privileges init_privs collate matview
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy create_misc gin gist
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file join_hash
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_dml
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gangsize
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gp_unique_rowid
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gporca
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_functions_idf
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_functions_idf opr_sanity
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_left_anti_semi_join
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_subquery
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file DML_over_joins
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file alter_db_set_tablespace
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gpsd alter_db_set_tablespace
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file enable_autovacuum session_reset fts_error alter_db_set_tablespace
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file expand_table_regression temp_relation alter_db_set_tablespace oid_wraparound
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file partition1
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file partition
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gp_query_id
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table copy prepare
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gp_tsrf
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gp_explain
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file update_gp
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_dml gangsize gp_unique_rowid gporca partition_pruning qp_subquery update_gp
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file createdb gp_tablespace_with_faults gp_tablespace temp_tablespaces default_tablespace
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file default_tablespace
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gp_tablespace temp_tablespaces default_tablespace
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file temp_tablespaces
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gpcopy
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file copy2
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file with_clause
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int4 int8 float8 varchar char text point polygon circle copy create_aggregate create_misc create_index aggregates
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file with
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file with rowtypes
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy bitmapscan bitmapscan_ao join_gp
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 point polygon circle copy create_misc create_index bitmapscan bitmapscan_ao join_gp
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 point polygon circle copy create_misc join_gp
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int4 copy join_gp
#make -j$(nproc) installcheck -i
popd
