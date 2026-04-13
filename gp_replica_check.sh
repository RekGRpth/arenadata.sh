#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/gp_replica_check.log")

pushd "$HOME/gpdb_src/gpcontrib/gp_replica_check"
make -j$(nproc) clean
make -j$(nproc) install
make -j$(nproc) installcheck
popd
