#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/madlib$GP_MAJOR.log")

createdb madlib || echo $?

pushd "$HOME/src/madlib"
./configure
make -j$(nproc) install
pushd build
mkdir -p "$HOME/src/madlib/tmp$GP_MAJOR"
./src/bin/madpack -d "$HOME/src/madlib/tmp$GP_MAJOR" -l -p greenplum -v -c /madlib install
popd
popd
