#!/bin/sh -eux

(
cd "$HOME/gpdb_src/contrib/citext"
make -j"$(nproc)" installcheck
) 2>&1 | tee "$HOME/citext.log"
