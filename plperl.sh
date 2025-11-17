#!/bin/sh -eux

(
cd "$HOME/gpdb_src/src/pl/plperl"
make -j"$(nproc)" installcheck
) 2>&1 | tee "$HOME/plperl.log"
