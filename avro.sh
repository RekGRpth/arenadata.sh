#!/bin/sh -eux

(
cd "$HOME/src/avro/lang/c"
git checkout ADBDEV-1513
cmake .
make -j"$(nproc)" install
cd /usr/local/lib
ln -fs ../lib64/libavro.so.23 libavro.so.23
) 2>&1 | tee "$HOME/avro.log"
