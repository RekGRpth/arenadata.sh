#!/bin/sh -eux

(
cd "$HOME/src/pgbackrest/src"
./configure --enable-test --prefix="$HOME/.local$GP_MAJOR"
make -j"$(nproc)" install
gpconfig -c archive_mode -v on
gpconfig -c archive_command -v "'PGOPTIONS=\"-c gp_session_role=utility\" pgbackrest --stanza=seg%c --config=/home/pgbackrest.conf archive-push %p'" --skipvalidation
gpstop -afr
PGOPTIONS="-c gp_session_role=utility" pgbackrest stanza-create --stanza=seg-1 --config=/home/pgbackrest.conf
PGOPTIONS="-c gp_session_role=utility" pgbackrest stanza-create --stanza=seg0 --config=/home/pgbackrest.conf
PGOPTIONS="-c gp_session_role=utility" pgbackrest stanza-create --stanza=seg1 --config=/home/pgbackrest.conf
PGOPTIONS="-c gp_session_role=utility" pgbackrest stanza-create --stanza=seg2 --config=/home/pgbackrest.conf
) 2>&1 | tee "$HOME/pgbackrest.log"
#PGOPTIONS="-c gp_session_role=utility" pgbackrest stanza-upgrade --stanza=seg-1 --config=/home/pgbackrest.conf
