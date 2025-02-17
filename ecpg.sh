#!/bin/bash -eux

(
cd "$HOME/src/gpdb$GP_MAJOR/src/interfaces/ecpg"
make -j$(nproc) installcheck -i
) 2>&1 | tee "$HOME/ecpg.log"
