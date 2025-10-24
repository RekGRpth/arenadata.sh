#!/bin/sh -eux

(
cd "$HOME/gpdb_src/src/backend/utils/gdd"
make -j$(nproc) installcheck -i
) 2>&1 | tee "$HOME/gdd.log"
