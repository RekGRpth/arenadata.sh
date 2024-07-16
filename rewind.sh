#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR/src/bin/pg_rewind"
#make -j$(nproc) clean
#make -j$(nproc) install
#make -j$(nproc) installcheck
#prove t/107_my.pl
#TESTDIR="$HOME/src/gpdb7/src/bin/pg_rewind" PATH="/usr/local/bin:$PATH" PGPORT='65432' top_builddir="$HOME/src/gpdb7/src/bin/pg_rewind/../../.." PG_REGRESS="$HOME/src/gpdb7/src/bin/pg_rewind/../../../src/test/regress/pg_regress" /usr/bin/prove -I ../../../src/test/perl/ -I .  t/107_my.pl
rm -rf "$HOME/src/gpdb$GP_MAJOR/src/bin/pg_rewind/tmp_check"
TESTDIR="$HOME/src/gpdb$GP_MAJOR/src/bin/pg_rewind" top_builddir="$HOME/src/gpdb$GP_MAJOR/src/bin/pg_rewind/../../.." PG_REGRESS="$HOME/src/gpdb$GP_MAJOR/src/bin/pg_rewind/../../../src/test/regress/pg_regress" /usr/bin/prove -I ../../../src/test/perl/ -I .  t/107_my.pl
#make -j$(nproc) check-local
#make -j$(nproc) check-remote
#export TEST_SUITE=remote
#export TEST_SUITE=local
#TEST_SUITE="local" "$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --inputdir=. --init-file=./regress_init_file --use-existing --launcher=./launcher my
#"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --inputdir=. --init-file=./regress_init_file --use-existing --launcher=./launcher basictest extrafiles databases pg_xlog_symlink unclean_shutdown simple_no_rewind_required ao_rewind
) 2>&1 | tee "$HOME/rewind.log"
#../../../src/test/regress/pg_regress --inputdir=. --psqldir= --init-file=./regress_init_file --use-existing --launcher=./launcher my