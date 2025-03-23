#!/bin/bash -eux

(
export COPT="-Werror -Wno-shadow=compatible-local"
cd "$HOME/src/pg_task"
make -j"$(nproc)" USE_PGXS=1 clean
make -j"$(nproc)" USE_PGXS=1
make -j"$(nproc)" USE_PGXS=1 install
if [[ "$GP_MAJOR" == "6c" || "$GP_MAJOR" == "6u" ]]; then
    gpconfig -c max_worker_processes -v 100 --masteronly
    gpconfig -c pg_task.json -v "'[{\"data\":\"gpadmin\",\"user\":\"gpadmin\"}]'" --masteronly --skipvalidation
elif [[ "$GP_MAJOR" == "7c" || "$GP_MAJOR" == "7u" ]]; then
    gpconfig -c max_worker_processes -v 100 --coordinatoronly
    gpconfig -c pg_task.json -v "'[{\"data\":\"gpadmin\",\"user\":\"gpadmin\"}]'" --coordinatoronly --skipvalidation
fi
gpconfig -c shared_preload_libraries -v "$(psql -At -c "SELECT array_to_string(array_append(string_to_array(current_setting('shared_preload_libraries'), ','), 'pg_task'), ',')" postgres)"
gpstop -afr
#exit
#export PGUSER=postgres
export PGDATABASE=gpadmin
make -j"$(nproc)" USE_PGXS=1 MYSQL=0 SQLITE3=0 installcheck CONTRIB_TESTDB="$PGDATABASE"
) 2>&1 | tee pg_task.log
