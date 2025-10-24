#!/bin/sh -eux

(
export TESTDIR="$HOME/gpdb_src/src/bin/scripts"
cd "$TESTDIR"
rm -rf tmp_check tmp_check_copy
#make -j$(nproc) installcheck -i
#exit
export top_builddir="$HOME/gpdb_src"
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
#prove --verbose -I ../../../src/test/perl/ t/010_pg_basebackup.pl t/050_check_replication.pl
#prove --verbose -I ../../../src/test/perl/ t/011_clusterdb_all.pl
#prove --verbose -I ../../../src/test/perl/ t/050_dropdb.pl
#prove --verbose -I ../../../src/test/perl/ t/091_reindexdb_all.pl
#prove --verbose -I ../../../src/test/perl/ t/101_vacuumdb_all.pl
#prove --verbose -I ../../../src/test/perl/ t/080_pg_isready.pl
prove --verbose -I ../../../src/test/perl/ t/090_reindexdb.pl
#prove --verbose -I ../../../src/test/perl/ t/020_pg_receivewal.pl
#prove --verbose -I ../../../src/test/perl/ t/010_pg_basebackup.pl
#prove --verbose -I ../../../src/test/perl/ t/123_streaming_and_archiving_with_archive_mode_always.pl
) 2>&1 | tee "$HOME/scripts.log"
