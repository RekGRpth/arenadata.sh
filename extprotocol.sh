#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/extprotocol.log")

export PGOPTIONS="-c optimizer=off"

pushd "$HOME/src/gpdb$GP_MAJOR/contrib/extprotocol"
make -j"$(nproc)" installcheck
popd
