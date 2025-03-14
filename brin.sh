#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR/src/test/modules/brin"
make -j"$(nproc)" installcheck
) 2>&1 | tee "$HOME/brin.log"
