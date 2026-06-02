#!/bin/sh -eux

(
cd "$HOME/gpdb_src/src/test/modules/test_metadata"
make -j"$(nproc)" installcheck -i
) 2>&1 | tee "$HOME/metadata.log"
