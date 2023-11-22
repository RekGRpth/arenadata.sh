#!/bin/sh -eux

(
cd "$HOME/src/kafka-adb"
make -j"$(nproc)" clean
make -j"$(nproc)" install
) 2>&1 | tee "$HOME/kafka-adb.log"
