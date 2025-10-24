#!/bin/sh -eux

(
cd "$HOME/gpdb_src/src/test/authentication"
make -j$(nproc) installcheck -i
) 2>&1 | tee "$HOME/authentication.log"
