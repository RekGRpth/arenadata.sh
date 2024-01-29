#!/bin/sh -eux

(
#export PGOPTIONS="-c optimizer=off"
cd "$HOME/src/gpdb$GP_MAJOR/src/test/regress"
#make -j$(nproc) clean
make -j$(nproc) install
ln -fs "$HOME/src/gpdb$GP_MAJOR/src/test/regress/regress.so" /usr/local/lib/postgresql/regress.so
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_catalog bfv_olap bfv_statistic bfv_index bfv_partition_plans bfv_aggregate bfv_partition DML_over_joins gporca
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file appendonly
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy with
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file uaocs_compaction/outdatedindex
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file sirv_functions appendonly alter_distpol_dropped vacuum_gp sreh
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file appendonly
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_dropped_cols
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file external_table
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file updatable_views union olap_window_seq
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int4 int8 float8 varchar char text copy union olap_window_seq
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_olap olap_setup olap_window_seq
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file rpt
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file alter_table_ao alter_table_aocs
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file scale_factor
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file bfv_planner explain_format gp_recursive_cte gporca rpt scale_factor
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy subselectMY
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file --schedule=./greenplum_schedule.test
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file --schedule=./greenplum_schedule.test2
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file --schedule=./greenplum_schedule.test2
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file qp_correlated_query
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file gp_unique_rowid
./pg_regress --load-extension=gp_inject_fault --init-file=init_file dispatch
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file not_out_of_shmem_exit_slots
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy create_misc rangefuncs_cdb gp_dqa subselect_gp
#make -j$(nproc) installcheck -i
) 2>&1 | tee "$HOME/regress.log"
