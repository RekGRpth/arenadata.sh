#!/bin/bash -eux

(
cd "$HOME/gpdb_src/src/interfaces/ecpg"
make -j$(nproc) installcheck -i
) 2>&1 | tee "$HOME/ecpg.log"
