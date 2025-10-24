#!/bin/sh -eux

(
cd "$HOME/gpdb_src/src/test/modules/brin"
make -j"$(nproc)" installcheck
) 2>&1 | tee "$HOME/brin.log"
