#!/bin/bash -eux

#exec 2>&1 &> >(tee "$HOME/unittest.log")

exec 2>&1 &> >(tee "$HOME/unittest.log")
export GPROOT="$GPHOME"
export CFLAGS=-DUNITTEST
pushd "$HOME/gpdb_src/src/backend/fts"
#pushd "$HOME/gpdb_src/src/backend/utils/sort"
#pushd "$HOME/gpdb_src/src/backend/cdb/dispatcher"
#pushd "$HOME/gpdb_src"
#pushd "$HOME/gpdb_src/src/backend/access/appendonly"
#make -j"$(nproc)" CFLAGS=-DUNITTEST -s unittest-check
make -j"$(nproc)" -s unittest-check
popd
exit

cd "$HOME/gpdb_src"
make GPROOT=/usr/local -j"$(nproc)" -s unittest-check
exit

exec 2>&1 &> >(tee "$HOME/unittest.log")
pushd "$HOME/gpdb_src/src/backend/access/appendonly"
make CFLAGS=-DUNITTEST -s unittest-check
popd
exit

exec 2>&1 &> >(tee "$HOME/unittest.log")
pushd "$HOME/gpdb_src/src/backend/utils/sort"
make CFLAGS=-DUNITTEST -s unittest-check
popd
exit

#(
cd "$HOME/gpdb_src/src/backend/cdb/dispatcher"
export CFLAGS="-O0 -ggdb -g3 -fno-omit-frame-pointer -Wclobbered -DUNITTEST"
make -C test check
exit
cd "$HOME/gpdb_src/src/backend"
make CFLAGS=-DUNITTEST -s unittest-check
exit
cd "$HOME/gpdb_src"
make GPROOT=/usr/local -j"$(nproc)" -s unittest-check
#) 2>&1 | tee "$HOME/unittest.log"
