#!/bin/sh -eux

(
cd "$HOME/src/diskquota"
make -j"$(nproc)" install
gpconfig -c shared_preload_libraries -v diskquota
gpstop -afr
) 2>&1 | tee "$HOME/diskquota.log"
