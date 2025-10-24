#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/gppc.log")

#export PGOPTIONS="-c optimizer=off"

pushd "$HOME/gpdb_src/src/interfaces/gppc"
make -j"$(nproc)" installcheck
popd
