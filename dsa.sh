#!/bin/sh -eux

(
cd "$HOME/gpdb_src/src/test/modules/test_dsa"
make -j"$(nproc)" installcheck
) 2>&1 | tee "$HOME/dsa.log"
