#!/bin/sh -eux

(
cd "$HOME/src/pgbackrest/src"
./configure --enable-test --prefix="$HOME/.local$GP_MAJOR"
#./configure --prefix="$HOME/.local$GP_MAJOR"
make -j"$(nproc)" install
if [ ! -d "$HOME/.data$GP_MAJOR/pgbackrest" ]; then
    gpconfig -c archive_mode -v on
    gpconfig -c archive_command -v "'PGOPTIONS=\"-c gp_session_role=utility\" pgbackrest --stanza=seg%c --config=/home/pgbackrest.conf archive-push %p'" --skipvalidation
    gpstop -afr
    mkdir -p "$HOME/.data$GP_MAJOR/pgbackrest"
    PGOPTIONS="-c gp_session_role=utility" pgbackrest stanza-create --stanza=seg-1 --config=/home/pgbackrest.conf
    PGOPTIONS="-c gp_session_role=utility" pgbackrest stanza-create --stanza=seg0 --config=/home/pgbackrest.conf
    PGOPTIONS="-c gp_session_role=utility" pgbackrest stanza-create --stanza=seg1 --config=/home/pgbackrest.conf
    PGOPTIONS="-c gp_session_role=utility" pgbackrest stanza-create --stanza=seg2 --config=/home/pgbackrest.conf
fi
) 2>&1 | tee "$HOME/pgbackrest.log"
#PGOPTIONS="-c gp_session_role=utility" pgbackrest stanza-upgrade --stanza=seg-1 --config=/home/pgbackrest.conf
#uncrustify -c pgbackrest/test/uncrustify.cfg --replace pgbackrest/src/common/io/read.h
#pgbackrest/test/test.pl --gen-check --no-coverage-report --vm=none --c-only --no-valgrind --vm-out --module=common --test=io
#pgbackrest/test/test.pl --gen-check --no-coverage-report --vm=none --c-only --no-valgrind --vm-out --module=command --test=backup
