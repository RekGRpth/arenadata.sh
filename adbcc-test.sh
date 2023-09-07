#!/bin/sh -eux

(
cd "$HOME/src/adbcc/adcc-extension"
make -j"$(nproc)" installcheck
) 2>&1 | tee "$HOME/adbcc-test.log"
