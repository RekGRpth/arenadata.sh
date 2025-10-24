#!/bin/sh -eux

(
cd "$HOME/gpdb_src/src/test/walrep"
make -j$(nproc) installcheck -i
) 2>&1 | tee "$HOME/walrep.log"
