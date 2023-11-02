#!/bin/sh -eux

(
cd "$HOME/src/avro/lang/c"
git checkout ADBDEV-1513
cmake .
make -j"$(nproc)" install
) 2>&1 | tee "$HOME/avro.log"
