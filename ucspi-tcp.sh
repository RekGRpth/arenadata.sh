#!/bin/sh -eux

(
cd "$HOME/src/ucspi-tcp"
make -j"$(nproc)" tcpserver
make -j"$(nproc)" install
) 2>&1 | tee "$HOME/ucspi-tcp.log"
