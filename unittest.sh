#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR/src/backend/cdb/dispatcher"
#test/cdbdisp_query.t
export CFLAGS="-O0 -ggdb -g3 -fno-omit-frame-pointer -Wclobbered -DUNITTEST"
make -C test check
#make CFLAGS=-DUNITTEST GPROOT=/usr/local -C test check
#make GPROOT=/usr/local -C test check
exit
cd "$HOME/src/gpdb$GP_MAJOR/src/backend"
make CFLAGS=-DUNITTEST GPROOT=/usr/local -s unittest-check
exit
cd "$HOME/src/gpdb$GP_MAJOR"
make GPROOT=/usr/local -j"$(nproc)" -s unittest-check
#make -j"$(nproc)" unittest-check
) 2>&1 | tee "$HOME/unittest.log"
