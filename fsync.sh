#!/bin/sh -eux

(
cd "$HOME/gpdb_src/src/test/fsync"
make -j$(nproc) installcheck -i
) 2>&1 | tee "$HOME/fsync.log"
