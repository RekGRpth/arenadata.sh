#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/gg_wait_sampling.log")

pushd "$HOME/gpdb_src/gpcontrib/gg_wait_sampling"
make -j$(nproc) clean
make -j$(nproc) install
make -j$(nproc) installcheck
make -j$(nproc) -C isolation2 installcheck
popd
