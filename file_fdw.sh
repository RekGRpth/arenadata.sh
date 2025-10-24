#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/file_fdw.log")

export PGOPTIONS="-c optimizer=off"

pushd "$HOME/gpdb_src/contrib/file_fdw"
make -j"$(nproc)" installcheck
popd
