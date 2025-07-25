#!/bin/sh -eux

(
export TESTDIR="$HOME/src/gpdb$GP_MAJOR/src/bin/pg_rewind"
cd "$TESTDIR"
rm -rf tmp_check tmp_check_copy
#make -j$(nproc) installcheck -i
#exit
export top_builddir="$HOME/src/gpdb$GP_MAJOR"
export PG_REGRESS="$top_builddir/src/test/regress/pg_regress"
export REGRESS_SHLIB="$top_builddir/src/test/regress/regress.so"
export TESTDATADIR="$TESTDIR/tmp_check"
export TESTLOGDIR="$TESTDATADIR/log"
prove --verbose -I ../../../src/test/perl/ t/001_basic.pl
#prove --verbose -I ../../../src/test/perl/ t/003_extrafiles.pl
exit
#make -j$(nproc) clean
#make -j$(nproc) install
#make -j$(nproc) installcheck
#prove t/107_my.pl
#TESTDIR="$HOME/src/gpdb7/src/bin/pg_rewind" PATH="/usr/local/bin:$PATH" PGPORT='65432' top_builddir="$HOME/src/gpdb7/src/bin/pg_rewind/../../.." PG_REGRESS="$HOME/src/gpdb7/src/bin/pg_rewind/../../../src/test/regress/pg_regress" /usr/bin/prove -I ../../../src/test/perl/ -I .  t/107_my.pl
rm -rf "$HOME/src/gpdb$GP_MAJOR/src/bin/pg_rewind/tmp_check"
#TESTDIR="$HOME/src/gpdb$GP_MAJOR/src/bin/pg_rewind" top_builddir="$HOME/src/gpdb$GP_MAJOR/src/bin/pg_rewind/../../.." PG_REGRESS="$HOME/src/gpdb$GP_MAJOR/src/bin/pg_rewind/../../../src/test/regress/pg_regress" /usr/bin/prove -I ../../../src/test/perl/ -I .  t/107_my.pl
#make -j$(nproc) check-local
#make -j$(nproc) check-remote
#export TEST_SUITE=remote
#export TEST_SUITE=local
#TEST_SUITE="local" "$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --inputdir=. --init-file=./regress_init_file --use-existing --launcher=./launcher wal
#TEST_SUITE="local" top_builddir="../../.." "../../test/regress/pg_regress" --inputdir=. --init-file=./regress_init_file --use-existing --launcher=./launcher wal
TEST_SUITE="local" bindir="/usr/local/bin" "../../test/regress/pg_regress" --inputdir=. --init-file=./regress_init_file --use-existing --launcher=./launcher wal
#"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --inputdir=. --init-file=./regress_init_file --use-existing --launcher=./launcher basictest extrafiles databases pg_xlog_symlink unclean_shutdown simple_no_rewind_required ao_rewind
) 2>&1 | tee "$HOME/rewind.log"
#../../../src/test/regress/pg_regress --inputdir=. --psqldir= --init-file=./regress_init_file --use-existing --launcher=./launcher my