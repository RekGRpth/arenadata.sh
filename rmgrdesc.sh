#!/bin/sh -eux

(
cd "$HOME/gpdb_src/src/backend/access/rmgrdesc"
export CFLAGS="-O0 -ggdb -g3 -fno-omit-frame-pointer -Wclobbered -DUNITTEST"
make -C test check
exit
cd "$HOME/gpdb_src/src/backend"
make CFLAGS=-DUNITTEST -s unittest-check
exit
cd "$HOME/gpdb_src"
make GPROOT=/usr/local -j"$(nproc)" -s unittest-check
) 2>&1 | tee "$HOME/rmgrdesc.log"
