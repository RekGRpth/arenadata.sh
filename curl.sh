#!/bin/sh -eux

(
cd "$HOME/src/curl"
autoreconf -vif
#./configure --without-gnutls
./configure
make -j"$(nproc)"
) 2>&1 | tee "$HOME/curl.log"
