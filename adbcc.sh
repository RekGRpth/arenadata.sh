#!/bin/sh -eux

(
cd "$HOME/src/adbcc/adcc-extension"
make -j"$(nproc)" clean
make -j"$(nproc)" install
cd "$HOME/src/adbcc/adcc-extension/test/socket"
make -j"$(nproc)" clean
make -j"$(nproc)" install
gpconfig -c shared_preload_libraries -v 'gpadcc'
gpconfig -c gp_enable_query_metrics -v on
psql -c "CREATE EXTENSION IF NOT EXISTS gpadcc"
gpstop -afr
gpconfig -c adcc.monitor_inner_queries -v on
gpconfig -c adcc.monitor_utility_inner_queries -v on
gpstop -u
) 2>&1 | tee "$HOME/adbcc.log"
