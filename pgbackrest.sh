#!/bin/sh -eux

(
cd "$HOME/src/pgbackrest/src"
./configure --enable-test
#./configure --enable-test --prefix="$HOME/.local$GP_MAJOR"
#./configure --prefix="$HOME/.local$GP_MAJOR"
make -j"$(nproc)" clean
exit
make -j"$(nproc)" install
rm -rf "$HOME/.data/$GP_MAJOR/pgbackrest"
if [ ! -d "$HOME/.data/$GP_MAJOR/pgbackrest" ]; then
    gpconfig -c archive_mode -v on
    gpconfig -c archive_command -v "'PGOPTIONS=\"-c gp_session_role=utility\" pgbackrest --stanza=seg%c --config=\"$HOME/pgbackrest.conf\" archive-push %p'" --skipvalidation
    gpstop -afr
    mkdir -p "$HOME/.data/$GP_MAJOR/pgbackrest"
    PGOPTIONS="-c gp_session_role=utility" pgbackrest stanza-create --stanza=seg-1 --config="$HOME/pgbackrest.conf"
    PGOPTIONS="-c gp_session_role=utility" pgbackrest stanza-create --stanza=seg0 --config="$HOME/pgbackrest.conf"
    PGOPTIONS="-c gp_session_role=utility" pgbackrest stanza-create --stanza=seg1 --config="$HOME/pgbackrest.conf"
    PGOPTIONS="-c gp_session_role=utility" pgbackrest stanza-create --stanza=seg2 --config="$HOME/pgbackrest.conf"
fi
) 2>&1 | tee "$HOME/pgbackrest.log"
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
