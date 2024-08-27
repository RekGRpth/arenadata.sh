#!/bin/sh -eux

(
cd "$HOME/src/pgbackrest"
arenadata/scripts/test_pitr_gpdb6.sh
) 2>&1 | tee "$HOME/pgbackrest-test.log"
