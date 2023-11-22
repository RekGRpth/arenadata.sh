#!/bin/sh -eux

(
cd "$HOME/src/librdkafka"
./configure
make -j"$(nproc)"
make -j"$(nproc)" install
) 2>&1 | tee "$HOME/librdkafka.log"
