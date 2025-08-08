#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/dblink.log")

export PGOPTIONS="-c optimizer=off"

pushd "$HOME/src/gpdb$GP_MAJOR/contrib/dblink"
make -j"$(nproc)" installcheck
popd
