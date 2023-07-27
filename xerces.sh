#!/bin/sh -eux

(
cd "$HOME/src/gp-xerces"
./configure --prefix=/usr/local
make -j"$(nproc)" install
) 2>&1 | tee "$HOME/xerces.log"
