#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/postgres_fdw.log")

pushd "$HOME/src/gpdb$GP_MAJOR/contrib/postgres_fdw"
#make -j"$(nproc)" clean
#make -j"$(nproc)"
make -j"$(nproc)" install
make -j"$(nproc)" installcheck
popd
