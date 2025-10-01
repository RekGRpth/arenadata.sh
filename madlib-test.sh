#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/madlib$GP_MAJOR.log")

pushd "$HOME/src/madlib"
make -j$(nproc) install
popd

rm -rf "$DATADIRS/madlib"
mkdir -p "$DATADIRS/madlib"
#/usr/local/madlib/Current/madpack/madpack.py -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l dev-check -t pmml/pmml
#/usr/local/madlib/Current/madpack/madpack.py -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l dev-check -t pmml/pmml_rf
#/usr/local/madlib/Current/madpack/madpack.py -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l dev-check -t pmml/pmml_check_fields
/usr/local/madlib/Current/madpack/madpack.py -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l dev-check -t dbscan
exit
#/usr/local/madlib/Current/madpack/madpack.py -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l install
/usr/local/madlib/Current/madpack/madpack.py -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l install-check
/usr/local/madlib/Current/madpack/madpack.py -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l dev-check
/usr/local/madlib/Current/madpack/madpack.py -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l unit-test
