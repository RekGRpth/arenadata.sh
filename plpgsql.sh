#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/plpgsql.log")

export PGOPTIONS="-c optimizer=off"

#(
pushd "$HOME/src/gpdb$GP_MAJOR/src/pl/plpgsql"
make -j"$(nproc)" installcheck
popd
#) 2>&1 | tee "$HOME/plpgsql.log"
