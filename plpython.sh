#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR/src/pl/plpython"
make -j"$(nproc)" installcheck
) 2>&1 | tee "$HOME/plpython.log"
