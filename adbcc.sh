#!/bin/sh -eux

(
cd "$HOME/src/adbcc/adcc-extension"
make -j"$(nproc)" install
gpconfig -c shared_preload_libraries -v 'gpadcc'
gpconfig -c gp_enable_query_metrics -v on
psql -c "CREATE EXTENSION IF NOT EXISTS gpadcc"
gpstop -afr
) 2>&1 | tee "$HOME/adbcc.log"
