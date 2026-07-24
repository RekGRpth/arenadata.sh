#!/bin/sh -eux

(
cd "$HOME/gpdb_src/contrib/sslinfo"
make -j"$(nproc)" installcheck -i
) 2>&1 | tee "$HOME/sslinfo.log"
