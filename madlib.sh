#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/madlib$GP_MAJOR.log")

createdb madlib || echo $?

pushd "$HOME/src/madlib"
#rm -rf build
#mkdir -p "build$GP_MAJOR"
#pushd "build$GP_MAJOR"
#mkdir -p build
#pushd build
#export GREENPLUM_EXECUTABLE=/usr/local/bin
#cmake ..
#make -j$(nproc) clean
#make -j$(nproc)
./configure
make -j$(nproc) install
#export PGDATABASE=madlib
pushd build
./src/bin/madpack -p greenplum -v -c /madlib install
popd
popd
