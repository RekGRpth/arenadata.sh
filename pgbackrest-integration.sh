#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/pgbackrest-integration.log")

pushd "$HOME/src"
#PKG_CONFIG_PATH="$GPHOME/lib/pkgconfig" pgbackrest/test/test.pl --gen-check --no-coverage-report --vm=none --c-only --no-valgrind --vm-out --module=common --dry-run
#PKG_CONFIG_PATH="$GPHOME/lib/pkgconfig" pgbackrest/test/test.pl --gen-check --no-coverage-report --vm=none --c-only --no-valgrind --vm-out --module=command --dry-run
#PKG_CONFIG_PATH="$GPHOME/lib/pkgconfig" pgbackrest/test/test.pl --gen-check --no-coverage-report --vm=none --c-only --no-valgrind --vm-out --module=command --test=archive-common --log-level-test=debug --log-level=debug
rm -rf "$HOME/src/test"
PKG_CONFIG_PATH="$GPHOME/lib/pkgconfig" pgbackrest/test/test.pl --module=config --test=load --no-coverage --no-valgrind --c-only
popd
exit
#(
pushd "$HOME/src/pgbackrest/test/gpdb"
#cd "$HOME/src/pgbackrest/arenadata"
#bash run_docker.sh hub.adsw.io/library/gpdb6_regress:latest
#bash run_docker.sh hub.adsw.io/library/gpdb6_u22:latest
#) 2>&1 | tee "$HOME/pgbackrest-integration.log"
popd