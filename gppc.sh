#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/gppc.log")

#export PGOPTIONS="-c optimizer=off"

pushd "$HOME/src/gpdb$GP_MAJOR/src/interfaces/gppc"
make -j"$(nproc)" installcheck
popd
