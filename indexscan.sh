#!/bin/sh -eux

(
cd "$HOME/gpdb_src/contrib/indexscan"
make -j"$(nproc)" installcheck -i
) 2>&1 | tee "$HOME/indexscan.log"
