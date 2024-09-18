#!/bin/sh -eux

(
#cd "$HOME/src/pgbackrest/test/gpdb"
cd "$HOME/src/pgbackrest/arenadata"
#bash run_docker.sh hub.adsw.io/library/gpdb6_regress:latest
bash run_docker.sh hub.adsw.io/library/gpdb6_u22:latest
) 2>&1 | tee "$HOME/pgbackrest-integration.log"
