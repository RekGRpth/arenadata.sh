#!/bin/sh -eux

(
cd "$HOME/src/kafka-adb"
make -j"$(nproc)" clean
make -j"$(nproc)" install
gpstop -afr
) 2>&1 | tee "$HOME/kafka-adb.log"
