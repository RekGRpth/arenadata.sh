#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/cron.log")
pushd "$HOME/gpdb_src/gpcontrib/pg_cron"
make -j"$(nproc)" installcheck
popd
