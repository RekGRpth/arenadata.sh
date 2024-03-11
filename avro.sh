#!/bin/sh -eux

(
cd "$HOME/src/avro/lang/c"
git checkout ADBDEV-1513
git submodule sync --recursive
git submodule update --recursive
#make clean
cmake -D CMAKE_INSTALL_PREFIX="$GPHOME" .
#cmake .
make -j"$(nproc)" install
cd "$GPHOME"/lib
ln -fs ../lib64/libavro.so.23 libavro.so.23
) 2>&1 | tee "$HOME/avro.log"
