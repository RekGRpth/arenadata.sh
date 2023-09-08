#!/bin/sh -eux

(
cd "$HOME/src/gpbackup"
make -j"$(nproc)" depend
make -j"$(nproc)" build
make -j"$(nproc)" install
) 2>&1 | tee "$HOME/gpbackup.log"
