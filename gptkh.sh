#!/bin/sh -eux

(
cd "$HOME/src/gptkh"
PG_CFLAGS="-I/$HOME/src/pxf/fdw" make -j"$(nproc)" install
) 2>&1 | tee "$HOME/gptkh.log"
