#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR/gpMgmt"
make -j$(nproc) install
) 2>&1 | tee "$HOME/rebalance.log"
