#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/pgbouncer.log")

export DEBIAN_FRONTEND=noninteractive
sudo apt install ldap-utils slapd
pushd "$HOME/src/pgbouncer"
./autogen.sh
./configure --with-ldap --enable-cassert --with-pam
#./configure --with-ldap --with-pam
make -j"$(nproc)" clean
make -j"$(nproc)" install_pgbouncer
etc/optscan.sh
make -j"$(nproc)" -C test check
pip3 install -r requirements.txt
#PYTHONIOENCODING=utf8 pytest -n "$(nproc)" -r s
#export PGOPTIONS="-c gp_role=utility --gp_dbid=1 --gp_contentid=0"
killall -9 postgres || echo "$?"
export PGOPTIONS="-c gp_role=utility"
#PYTHONIOENCODING=utf8 pytest -n "$(nproc)" -r s -k test_ldap_auth
git apply "$(dirname "$0")/pgbouncer.diff"
set +e
PYTHONIOENCODING=utf8 pytest -k test_ldap_auth
code="$?"
set -e
git apply "$(dirname "$0")/pgbouncer-revert.diff"
popd
exit "$code"
