#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/pg_upgrade.log")

export PGOPTIONS="-c optimizer=off"

pushd "$HOME/gpdb_src/src/bin/pg_upgrade"
make -j"$(nproc)" check
popd
