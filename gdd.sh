#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR/src/backend/utils/gdd"
make -j$(nproc) installcheck -i
) 2>&1 | tee "$HOME/gdd.log"
