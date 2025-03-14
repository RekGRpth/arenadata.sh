#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR/src/test/modules/test_dsa"
make -j"$(nproc)" installcheck
) 2>&1 | tee "$HOME/dsa.log"
