#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/extprotocol.log")

export PGOPTIONS="-c optimizer=off"

pushd "$HOME/gpdb_src/contrib/extprotocol"
make -j"$(nproc)" installcheck
popd
