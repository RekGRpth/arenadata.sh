#!/bin/sh -eux

(
cd "$HOME/src/krb5/src"
autoreconf -vif
./configure
make -j"$(nproc)" clean
make -j"$(nproc)"
make -j"$(nproc)" install
) 2>&1 | tee "$HOME/krb5.log"
