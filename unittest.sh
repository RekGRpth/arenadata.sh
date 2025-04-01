#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR/src/backend/cdb/dispatcher"
export CFLAGS="-O0 -ggdb -g3 -fno-omit-frame-pointer -Wclobbered -DUNITTEST"
make -C test check
exit
cd "$HOME/src/gpdb$GP_MAJOR/src/backend"
make CFLAGS=-DUNITTEST -s unittest-check
exit
cd "$HOME/src/gpdb$GP_MAJOR"
make GPROOT=/usr/local -j"$(nproc)" -s unittest-check
) 2>&1 | tee "$HOME/unittest.log"
