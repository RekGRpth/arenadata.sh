#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR"
make -j"$(nproc)" clean
) 2>&1 | tee "$HOME/clean.log"
