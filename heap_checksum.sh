#!/bin/sh -eux

(
cd "$HOME/gpdb_src/src/test/heap_checksum"
make -j$(nproc) installcheck -i
) 2>&1 | tee "$HOME/heap_checksum.log"
