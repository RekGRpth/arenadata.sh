#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/plpgsql.log")

export PGOPTIONS="-c optimizer=off"

#(
pushd "$HOME/gpdb_src/src/pl/plpgsql"
make -j"$(nproc)" installcheck
popd
#) 2>&1 | tee "$HOME/plpgsql.log"
