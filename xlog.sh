#!/bin/sh -eux

(
#test -f "$HOME/data$GP_MAJOR/qddir/demoDataDir-1/postgresql.conf" && gpstop -af
find ~/data$GP_MAJOR/*/*/pg_xlog -type f ! -name "*.*" | xargs --verbose --no-run-if-empty --max-procs="$(nproc)" --replace=WAL sh -c "pg_xlogdump WAL > WAL.dump"
#gpstart -a
) 2>&1 | tee "$HOME/xlog.log"
