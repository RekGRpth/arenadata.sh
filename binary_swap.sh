#!/bin/sh -eux

(
#export PGOPTIONS="-c optimizer=on -c optimizer_enable_table_alias=off"
export PGOPTIONS="-c optimizer=off"
cd "$HOME/src/gpdb$GP_MAJOR/src/test/regress"
#make -j$(nproc) clean
#make -j$(nproc) install
./pg_regress --load-extension=gp_inject_fault --init-file=init_file aggregate_with_groupingsets alter_distribution_policy alter_table_aocs2 appendonly bb_mpph bfv_partition case_gp constraints dml_in_udf dsp index_constraint_naming_upgrade partition partition_ddl partition_locking partition_pruning qp_dml_joins qp_dml_oids qp_union_intersect qp_query_execution rle freeze_aux_tables
cd "$HOME/src/gpdb$GP_MAJOR/src/test/isolation2"
#make -j$(nproc) clean
make -j$(nproc) install
./pg_isolation2_regress  --init-file=../../../src/test/regress/init_file --init-file=./init_file_isolation2 --load-extension=gp_inject_fault setup lockmodes query_gp_partitions_view
#exit
cd "$HOME/src/gpdb$GP_MAJOR/src/test/binary_swap"
#createdb regression || echo $?
#createdb isolation2test || echo $?
./test_binary_swap.sh -b /usr/local.gp || echo $?
source /usr/local.gp/greenplum_path.sh
gpstop -a
source /usr/local/greenplum_path.sh
gpstart -a
) 2>&1 | tee "$HOME/binary_swap.log"
