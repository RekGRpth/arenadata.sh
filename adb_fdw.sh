#!/bin/sh -eux

(
cd "$HOME/src/adb_fdw"
make -j"$(nproc)" clean
make -j"$(nproc)"
make -j"$(nproc)" install
make -j"$(nproc)" installcheck
) 2>&1 | tee "$HOME/adb_fdw.log"
