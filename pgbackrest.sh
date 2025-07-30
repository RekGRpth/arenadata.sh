#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/pgbackrest.log")
#(
pushd "$HOME/src/pgbackrest/src"
./configure --enable-test
#./configure --enable-test --prefix="$HOME/.local$GP_MAJOR"
#./configure --prefix="$HOME/.local$GP_MAJOR"
#make -j"$(nproc)" clean
#exit
make -j"$(nproc)" install
#rm -rf "$DATADIRS/pgbackrest"
if [ ! -d "$DATADIRS/pgbackrest" ]; then
    gpconfig -c archive_mode -v on
    gpconfig -c archive_command --skipvalidation \
        -v "'PGOPTIONS=\"-c gp_session_role=utility\" pgbackrest --fork=GPDB --stanza=seg%c --pg1-path=\"$DATADIRS/dbfast1/demoDataDir%c\" archive-push %p'" \
        -m "'PGOPTIONS=\"-c gp_session_role=utility\" pgbackrest --fork=GPDB --stanza=seg%c --pg1-path=\"$DATADIRS/qddir/demoDataDir%c\" archive-push %p'"
    gpstop -afr
    mkdir -p "$DATADIRS/pgbackrest"
    sudo rm -rf /var/log/pgbackrest
    sudo rm -rf /var/lib/pgbackrest
    sudo ln -fs "$DATADIRS/pgbackrest" /var/log/pgbackrest
    sudo ln -fs "$DATADIRS/pgbackrest" /var/lib/pgbackrest
    PGOPTIONS="-c gp_session_role=utility" pgbackrest stanza-create --fork=GPDB --stanza=seg-1 --pg1-port="${GP_MAJOR}000" --pg1-path="$DATADIRS/qddir/demoDataDir-1"
    for (( i=1; i<=$NUM_PRIMARY_MIRROR_PAIRS; i++ )); do
        PGOPTIONS="-c gp_session_role=utility" pgbackrest stanza-create --fork=GPDB --stanza="seg$((i-1))" --pg1-port="${GP_MAJOR}00$((i+1))" --pg1-path="$DATADIRS/dbfast$i/demoDataDir$((i-1))"
    done
#    PGOPTIONS="-c gp_session_role=utility" pgbackrest stanza-create --fork=GPDB --stanza=seg0 --pg1-port="${GP_MAJOR}002" --pg1-path="$DATADIRS/dbfast1/demoDataDir0"
#    PGOPTIONS="-c gp_session_role=utility" pgbackrest stanza-create --fork=GPDB --stanza=seg1 --pg1-port="${GP_MAJOR}003" --pg1-path="$DATADIRS/dbfast2/demoDataDir1"
#    PGOPTIONS="-c gp_session_role=utility" pgbackrest stanza-create --fork=GPDB --stanza=seg2 --pg1-port="${GP_MAJOR}004" --pg1-path="$DATADIRS/dbfast3/demoDataDir2"
fi
#) 2>&1 | tee "$HOME/pgbackrest.log"
#PGOPTIONS="-c gp_session_role=utility" pgbackrest stanza-upgrade --stanza=seg-1 --config=/home/pgbackrest.conf
#uncrustify -c pgbackrest/test/uncrustify.cfg --replace pgbackrest/src/common/io/read.h
#pgbackrest/test/test.pl --gen-check --no-coverage-report --vm=none --c-only --no-valgrind --vm-out --code-format-check
#pgbackrest/test/test.pl --gen-check --no-coverage-report --vm=none --c-only --no-valgrind --vm-out --module=command --test=backup
#pgbackrest/test/test.pl --gen-check --no-coverage-report --vm=none --c-only --no-valgrind --vm-out --module=command --test=restore
#pgbackrest/test/test.pl --gen-check --no-coverage-report --vm=none --c-only --no-valgrind --vm-out --module=common --test=io
#pgbackrest/test/test.pl --gen-check --no-coverage-report --vm=none --c-only --no-valgrind --vm-out --module=common --test=io-http
#pgbackrest/test/test.pl --gen-check --no-coverage-report --vm=none --c-only --no-valgrind --vm-out --module=storage --test=sftp
#pgbackrest/test/test.pl --gen-check --no-coverage-report --vm=none --c-only --no-valgrind --vm-out --module=test --test=test
#pgbackrest/test/test.pl --gen-check --no-coverage-report --vm=none --c-only --no-valgrind --vm-out --module=common --test=walfilter
#pgbackrest/test/test.pl --gen-check --no-coverage-report --vm=none --c-only --no-valgrind --vm-out --module=command --test=archive-get
#pgbackrest/test/test.pl --gen-check --no-coverage-report --vm=none --c-only --no-valgrind --vm-out --module=postgres --test=interface
#PKG_CONFIG_PATH=/usr/local/lib/pkgconfig pgbackrest/test/test.pl --gen-check --no-coverage-report --vm=none --c-only --no-valgrind --vm-out --module=command --test=backup
popd
