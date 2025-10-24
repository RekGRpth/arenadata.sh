#!/bin/sh -eux

(
cd "$HOME/gpdb_src/gpMgmt"
make -j$(nproc) install
) 2>&1 | tee "$HOME/rebalance.log"
