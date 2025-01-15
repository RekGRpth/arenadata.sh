#!/bin/sh -eux

(
export TESTDIR="$HOME/src/gpdb$GP_MAJOR/src/test/recovery"
cd "$TESTDIR"
#make -j$(nproc) installcheck -i
rm -rf tmp_check
export top_builddir="$HOME/src/gpdb$GP_MAJOR"
export PG_REGRESS="$top_builddir/src/test/regress/pg_regress"
export REGRESS_SHLIB="$top_builddir/src/test/regress/regress.so"
#prove -I ../../../src/test/perl/ t/101_non_standby_recovery.pl
#prove -I ../../../src/test/perl/ t/139_archive_mode_always.pl
#prove -I ../../../src/test/perl/ t/121_streaming_and_archiving.pl
prove -I ../../../src/test/perl/ t/122_streaming_and_archiving.pl
) 2>&1 | tee "$HOME/recovery.log"
