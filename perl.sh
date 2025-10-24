#!/bin/sh -eux

(
cd "$HOME/gpdb_src/src/test/perl"
make -j$(nproc) install -i
) 2>&1 | tee "$HOME/perl.log"
