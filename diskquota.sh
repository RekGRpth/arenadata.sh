#!/bin/sh -eux

(
cd "$HOME/src/diskquota"
rm -rf build
mkdir -p build
cd build
#make -j"$(nproc)" clean
cmake ..
make -j"$(nproc)" install
gpconfig -c shared_preload_libraries -v diskquota-2.2
gpstop -afr
) 2>&1 | tee "$HOME/diskquota.log"
