#!/bin/sh -eux

(
cd "$HOME/src/curl"
autoreconf -vif
#./configure --without-gnutls
./configure --with-gnutls
make -j"$(nproc)"
) 2>&1 | tee "$HOME/curl.log"
