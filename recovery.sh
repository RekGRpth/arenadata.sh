#!/bin/sh -eux

(
export TESTDIR="$HOME/src/gpdb$GP_MAJOR/src/test/recovery"
cd "$TESTDIR"
rm -rf tmp_check tmp_check_copy
#make -j$(nproc) installcheck -i
#exit
export top_builddir="$HOME/src/gpdb$GP_MAJOR"
export PG_REGRESS="$top_builddir/src/test/regress/pg_regress"
export REGRESS_SHLIB="$top_builddir/src/test/regress/regress.so"
export TESTDATADIR="$TESTDIR/tmp_check"
export TESTLOGDIR="$TESTDATADIR/log"
#prove -I ../../../src/test/perl/ t/101_non_standby_recovery.pl
#prove --verbose -I ../../../src/test/perl/ t/139_archive_mode_always.pl
#prove --verbose -I ../../../src/test/perl/ t/140_archive_mode_always.pl
#prove --verbose -I ../../../src/test/perl/ t/005_replay_delay.pl
#prove --verbose -I ../../../src/test/perl/ t/121_streaming_and_archiving.pl
#prove --verbose -I ../../../src/test/perl/ t/122_streaming_and_archiving.pl
#prove --verbose -I ../../../src/test/perl/ t/123_streaming_and_archiving.pl
#prove --verbose -I ../../../src/test/perl/ t/020_archive_status.pl
#prove --verbose -I ../../../src/test/perl/ t/044_change_recovery_target.pl
#prove --verbose -I ../../../src/test/perl/ t/004_timeline_switch.pl
#prove --verbose -I ../../../src/test/perl/ t/010_logical_decoding_timelines.pl
#prove --verbose -I ../../../src/test/perl/ t/101_restore_point_and_startup_pause.pl
#prove --verbose -I ../../../src/test/perl/ t/050_check_recovery_backup.pl
prove --verbose -I ../../../src/test/perl/ t/037_invalid_database.pl
#prove --verbose -I ../../../src/test/perl/ t/039_end_of_wal.pl
#prove --verbose -I ../../../src/test/perl/ t/039_end_of_wal.1.pl
#prove --verbose -I ../../../src/test/perl/ t/031_recovery_conflict.pl
#prove --verbose -I ../../../src/test/perl/ t/013_crash_restart.pl
#prove --verbose -I ../../../src/test/perl/ t/123_streaming_and_archiving_with_archive_mode_always.pl
) 2>&1 | tee "$HOME/recovery.log"
