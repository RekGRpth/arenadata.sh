#!/bin/sh -eux

(
createdb contrib_regression || echo $?
cd "$HOME/src/gpdb$GP_MAJOR/src/test/isolation2"
make -j$(nproc) install
#cd "$HOME/src/diskquota/tests/isolation2"
#cd "$HOME/src/diskquota/tests"
cd "$HOME/src/diskquota/tests"
ln -fs "../../gpdb$GP_MAJOR/src/test/isolation2/sql_isolation_testcase.py" sql_isolation_testcase.py
ln -fs "../../gpdb$GP_MAJOR/src/test/isolation2/global_sh_executor.sh" global_sh_executor.sh
#"$HOME/src/gpdb$GP_MAJOR/src/test/isolation2/pg_isolation2_regress" --inputdir=isolation2 --outputdir=isolation2 --init-file=init_file --load-extension=gp_inject_fault config test_create_extension test_dropped_table test_temporary_table test_drop_extension reset_config
"$HOME/src/gpdb$GP_MAJOR/src/test/isolation2/pg_isolation2_regress" --inputdir="$HOME/src/diskquota/build/tests/isolation2" --outputdir="$HOME/src/diskquota/build/tests/isolation2" --init-file=init_file --load-extension=gp_inject_fault test_create_extension test_dropped_table test_temporary_table test_drop_extension
#"$HOME/src/gpdb$GP_MAJOR/src/test/isolation2/pg_isolation2_regress" --inputdir="$HOME/src/diskquota/build/tests/isolation2" --outputdir="$HOME/src/diskquota/build/tests/isolation2" --init-file=init_file --load-extension=gp_inject_fault test_create_extension test_fast_quota_view test_drop_extension
#"$HOME/src/gpdb$GP_MAJOR/src/test/isolation2/pg_isolation2_regress" --inputdir=isolation2 --outputdir=isolation2 --init-file=init_file test_temporary
#"$HOME/src/gpdb$GP_MAJOR/src/test/isolation2/pg_isolation2_regress" --inputdir=isolation2 --outputdir=isolation2 --init-file=init_file test_dropped
#"$HOME/src/gpdb$GP_MAJOR/src/test/isolation2/pg_isolation2_regress" --inputdir=isolation2 --outputdir=isolation2 --init-file=init_file --load-extension=gp_inject_fault config test_create_extension test_truncate test_drop_extension reset_config
#./pg_isolation2_regress --inputdir="$HOME/src/diskquota/tests/isolation2" --outputdir="$HOME/src/diskquota/tests/isolation2" --init-file="$HOME/src/diskquota/tests/init_file" config reset_config
#./pg_isolation2_regress --inputdir="$HOME/src/diskquota/tests/isolation2" --outputdir="$HOME/src/diskquota/tests/isolation2" --init-file="$HOME/src/diskquota/tests/init_file" test_truncate
) 2>&1 | tee "$HOME/diskquota-isolation2.log"
