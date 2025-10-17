#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/madlib$GP_MAJOR.log")

which pip3 || curl https://bootstrap.pypa.io/pip/get-pip.py | python3

pip3 install \
    pyxb-x==1.2.6.1 \
    pyyaml==6.0.1

dropdb madlib || echo $?
createdb madlib || echo $?

rm -rf "$HOME/src/madlib/build/src/ports/green*/6/extension" "$HOME/src/madlib/build/src/ports/green*/7/extension"

pushd "$HOME/src/madlib"
./configure -Wno-dev
make -j$(nproc) extension-install
popd

psql -d madlib -c "create extension if not exists  plpython3u"
psql -d madlib -c "create schema if not exists madlib"
psql -d madlib -c "create extension if not exists madlib schema madlib"
