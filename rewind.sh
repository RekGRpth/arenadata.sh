#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/rewind.log")

#(
export TESTDIR="$HOME/gpdb_src/src/bin/pg_rewind"
pushd "$TESTDIR"
rm -rf tmp_check tmp_check_copy
#make -j$(nproc) installcheck -i
#exit
export top_builddir="$HOME/gpdb_src"
export PG_REGRESS="$top_builddir/src/test/regress/pg_regress"
export REGRESS_SHLIB="$top_builddir/src/test/regress/regress.so"
export TESTDATADIR="$TESTDIR/tmp_check"
export TESTLOGDIR="$TESTDATADIR/log"
#prove --verbose -I ../../../src/test/perl/ t/001_basic.pl
prove --verbose -I ../../../src/test/perl/ t/010_target_is_ancestor.pl
#prove --verbose -I ../../../src/test/perl/ t/107_empty_conf.pl
#prove --verbose -I ../../../src/test/perl/ t/003_extrafiles.pl
exit
#make -j$(nproc) clean
#make -j$(nproc) install
#make -j$(nproc) installcheck
#prove t/107_my.pl
#TESTDIR="$HOME/src/gpdb7/src/bin/pg_rewind" PATH="/usr/local/bin:$PATH" PGPORT='65432' top_builddir="$HOME/src/gpdb7/src/bin/pg_rewind/../../.." PG_REGRESS="$HOME/src/gpdb7/src/bin/pg_rewind/../../../src/test/regress/pg_regress" /usr/bin/prove -I ../../../src/test/perl/ -I .  t/107_my.pl
rm -rf "$HOME/gpdb_src/src/bin/pg_rewind/tmp_check"
#TESTDIR="$HOME/gpdb_src/src/bin/pg_rewind" top_builddir="$HOME/gpdb_src/src/bin/pg_rewind/../../.." PG_REGRESS="$HOME/gpdb_src/src/bin/pg_rewind/../../../src/test/regress/pg_regress" /usr/bin/prove -I ../../../src/test/perl/ -I .  t/107_my.pl
#make -j$(nproc) check-local
#make -j$(nproc) check-remote
#export TEST_SUITE=remote
#export TEST_SUITE=local
#TEST_SUITE="local" "$HOME/gpdb_src/src/test/regress/pg_regress" --inputdir=. --init-file=./regress_init_file --use-existing --launcher=./launcher wal
#TEST_SUITE="local" top_builddir="../../.." "../../test/regress/pg_regress" --inputdir=. --init-file=./regress_init_file --use-existing --launcher=./launcher wal
TEST_SUITE="local" bindir="/usr/local/bin" "../../test/regress/pg_regress" --inputdir=. --init-file=./regress_init_file --use-existing --launcher=./launcher wal
#"$HOME/gpdb_src/src/test/regress/pg_regress" --inputdir=. --init-file=./regress_init_file --use-existing --launcher=./launcher basictest extrafiles databases pg_xlog_symlink unclean_shutdown simple_no_rewind_required ao_rewind
#) 2>&1 | tee "$HOME/rewind.log"
#../../../src/test/regress/pg_regress --inputdir=. --psqldir= --init-file=./regress_init_file --use-existing --launcher=./launcher my
popd
