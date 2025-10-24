#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/plpython.log")

#export PGOPTIONS="-c optimizer=off"

pushd "$HOME/gpdb_src/src/pl/plpython"
make -j"$(nproc)" installcheck
popd
