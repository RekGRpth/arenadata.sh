#!/bin/sh -eux

(
cd "$HOME/src/pgbackrest/test/gpdb"
bash run_docker.sh hub.adsw.io/library/gpdb6_regress:latest
) 2>&1 | tee "$HOME/pgbackrest-integration.log"
