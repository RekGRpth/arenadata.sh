#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/dblink.log")

export PGOPTIONS="-c optimizer=off"

pushd "$HOME/gpdb_src/contrib/dblink"
make -j"$(nproc)" installcheck
popd
