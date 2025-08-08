#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/file_fdw.log")

export PGOPTIONS="-c optimizer=off"

pushd "$HOME/src/gpdb$GP_MAJOR/contrib/file_fdw"
make -j"$(nproc)" installcheck
popd
