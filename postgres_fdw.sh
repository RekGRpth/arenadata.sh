#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/postgres_fdw.log")

pushd "$HOME/gpdb_src/contrib/postgres_fdw"
#make -j"$(nproc)" clean
#make -j"$(nproc)"
make -j"$(nproc)" install
make -j"$(nproc)" installcheck
popd
