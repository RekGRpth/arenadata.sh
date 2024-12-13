#!/bin/sh -eux

(
cd "$HOME/src/adbcc"
git submodule update --init --recursive
cd "$HOME/src/adbcc/adcc-extension"
make -j"$(nproc)" clean
make -j"$(nproc)"
make -j"$(nproc)" install
cd "$HOME/src/adbcc/adcc-extension/test/socket"
make -j"$(nproc)" clean
make -j"$(nproc)"
make -j"$(nproc)" install
gpconfig -c shared_preload_libraries -v 'gpadcc'
gpconfig -c gp_enable_query_metrics -v on
psql -d postgres -c "CREATE EXTENSION IF NOT EXISTS gpadcc"
gpstop -afr
#gpconfig -c adcc.send_buffer_size -v 10485760;
gpconfig -c adcc.monitor_inner_queries -v on
gpconfig -c adcc.monitor_utility_inner_queries -v on
gpstop -u
) 2>&1 | tee "$HOME/adbcc.log"
