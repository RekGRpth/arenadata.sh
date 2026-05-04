#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/pgbouncer.log")

pushd "$HOME/src/pgbouncer"
./autogen.sh
./configure --with-ldap --enable-cassert --with-pam
#./configure --with-ldap --with-pam
make -j"$(nproc)" clean
make -j"$(nproc)" install_pgbouncer
etc/optscan.sh
make -j"$(nproc)" -C test check
popd
