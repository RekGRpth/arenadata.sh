#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/distclean.log")

#(
pushd "$HOME/gpdb_src"
make -j"$(nproc)" clean
#) 2>&1 | tee "$HOME/clean.log"
popd
