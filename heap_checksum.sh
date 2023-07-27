#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR/src/test/heap_checksum"
make -j$(nproc) installcheck -i
) 2>&1 | tee "$HOME/heap_checksum.log"
