#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/madlib$GP_MAJOR.log")

rm -rf /usr/local/madlib/Current/madpack/madpack.py

pushd "$HOME/src/madlib"
./configure -Wno-dev
make -j$(nproc) install
popd

rm -rf "$DATADIRS/madlib"
mkdir -p "$DATADIRS/madlib"
export PATH="$PATH:/usr/local/madlib/bin"
#madpack -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l dev-check -t pmml/pmml
#madpack -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l dev-check -t pmml/pmml_rf
#madpack -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l dev-check -t pmml/pmml_check_fields
madpack -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l dev-check -t dbscan
exit
#madpack -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l install
madpack -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l install-check
madpack -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l dev-check
madpack -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l unit-test
