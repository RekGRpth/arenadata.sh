#!/bin/sh -eux

(
export PGOPTIONS="-c optimizer=off"
cd "$HOME/gpdb_src/gpcontrib/gp_replica_check"
#make installcheck
make -j"$(nproc)" installcheck -i
#/home/gpadmin/src/gpdb7u/src/test/regress/pg_regress --inputdir=./ --load-extension=gp_inject_fault --schedule=parallel_schedule --encoding=utf8 --init-file=init_file --dbname=contrib_regression orafce orafce2 dbms_output dbms_utility files varchar2 nvarchar2 aggregates nlssort dbms_random regexp_func gp_partition_by gp_distributed_by dbms_sql
#"$HOME/gpdb_src/src/test/regress/pg_regress" --load-extension=gp_inject_fault --init-file=init_file --dbname=contrib_regression init dbms_random
) 2>&1 | tee "$HOME/gp_replica_check.log"
