#!/bin/sh -eux

(
export TESTDIR="$HOME/src/gpdb$GP_MAJOR/src/bin/pg_basebackup"
cd "$TESTDIR"
make -j$(nproc) installcheck -i
exit
rm -rf tmp_check tmp_check_copy
export top_builddir="$HOME/src/gpdb$GP_MAJOR"
export PG_REGRESS="$top_builddir/src/test/regress/pg_regress"
export REGRESS_SHLIB="$top_builddir/src/test/regress/regress.so"
#prove -I ../../../src/test/perl/ t/101_non_standby_recovery.pl
#prove --verbose -I ../../../src/test/perl/ t/139_archive_mode_always.pl
#prove --verbose -I ../../../src/test/perl/ t/140_archive_mode_always.pl
#prove --verbose -I ../../../src/test/perl/ t/005_replay_delay.pl
#prove --verbose -I ../../../src/test/perl/ t/121_streaming_and_archiving.pl
#prove --verbose -I ../../../src/test/perl/ t/122_streaming_and_archiving.pl
#prove --verbose -I ../../../src/test/perl/ t/123_streaming_and_archiving.pl
#prove --verbose -I ../../../src/test/perl/ t/020_archive_status.pl
prove --verbose -I ../../../src/test/perl/ t/010_pg_basebackup.pl t/050_check_replication.pl
#prove --verbose -I ../../../src/test/perl/ t/123_streaming_and_archiving_with_archive_mode_always.pl
) 2>&1 | tee "$HOME/basebackup.log"
