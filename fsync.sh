#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR/src/test/fsync"
make -j$(nproc) installcheck -i
) 2>&1 | tee "$HOME/fsync.log"
