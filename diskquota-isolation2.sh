#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/diskquota-isolation2.log")

#(
createdb contrib_regression || echo $?
psql -d isolation2test -c "drop extension diskquota" || echo $?
#pushd "$HOME/gpdb_src/src/test/isolation2"
#make -j$(nproc) install
#popd
#cd "$HOME/src/diskquota/tests/isolation2"
#cd "$HOME/src/diskquota/tests"
pushd "$HOME/src/diskquota/tests"
ln -fs "$HOME/gpdb_src/src/test/isolation2/sql_isolation_testcase.py" sql_isolation_testcase.py
ln -fs "$HOME/gpdb_src/src/test/isolation2/global_sh_executor.sh" global_sh_executor.sh
#"$HOME/gpdb_src/src/test/isolation2/pg_isolation2_regress" --inputdir=isolation2 --outputdir=isolation2 --init-file=init_file --load-extension=gp_inject_fault config test_create_extension test_dropped_table test_temporary_table test_drop_extension reset_config
#"$HOME/gpdb_src/src/test/isolation2/pg_isolation2_regress" --inputdir="$HOME/src/diskquota/build/tests/isolation2" --outputdir="$HOME/src/diskquota/build/tests/isolation2" --init-file=init_file --load-extension=gp_inject_fault test_create_extension test_dropped_table test_temporary_table test_drop_extension
#"$HOME/gpdb_src/src/test/isolation2/pg_isolation2_regress" --inputdir="$HOME/src/diskquota/build/tests/isolation2" --outputdir="$HOME/src/diskquota/build/tests/isolation2" --init-file=init_file config test_create_extension test_table_size_map_overflow reset_config
"$HOME/gpdb_src/src/test/isolation2/pg_isolation2_regress" --inputdir="$HOME/src/diskquota/build/tests/isolation2" --outputdir="$HOME/src/diskquota/build/tests/isolation2" --init-file=init_file test_table_size_map_overflow
#"$HOME/gpdb_src/src/test/isolation2/pg_isolation2_regress" --inputdir="$HOME/src/diskquota/build/tests/isolation2" --outputdir="$HOME/src/diskquota/build/tests/isolation2" --init-file=init_file config test_create_extension reset_config
#"$HOME/gpdb_src/src/test/isolation2/pg_isolation2_regress" --inputdir="$HOME/src/diskquota/build/tests/isolation2" --outputdir="$HOME/src/diskquota/build/tests/isolation2" --init-file=init_file --load-extension=gp_inject_fault test_create_extension test_fast_quota_view test_drop_extension
#"$HOME/gpdb_src/src/test/isolation2/pg_isolation2_regress" --inputdir=isolation2 --outputdir=isolation2 --init-file=init_file test_temporary
#"$HOME/gpdb_src/src/test/isolation2/pg_isolation2_regress" --inputdir=isolation2 --outputdir=isolation2 --init-file=init_file test_dropped
#"$HOME/gpdb_src/src/test/isolation2/pg_isolation2_regress" --inputdir=isolation2 --outputdir=isolation2 --init-file=init_file --load-extension=gp_inject_fault config test_create_extension test_truncate test_drop_extension reset_config
#./pg_isolation2_regress --inputdir="$HOME/src/diskquota/tests/isolation2" --outputdir="$HOME/src/diskquota/tests/isolation2" --init-file="$HOME/src/diskquota/tests/init_file" config reset_config
#./pg_isolation2_regress --inputdir="$HOME/src/diskquota/tests/isolation2" --outputdir="$HOME/src/diskquota/tests/isolation2" --init-file="$HOME/src/diskquota/tests/init_file" test_truncate
#) 2>&1 | tee "$HOME/diskquota-isolation2.log"
popd
