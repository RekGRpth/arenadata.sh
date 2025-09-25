#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/madlib$GP_MAJOR.log")

if ! which pip3; then
    curl https://bootstrap.pypa.io/pip/get-pip.py -o get-pip.py; \
    python3 get-pip.py; \
    rm get-pip.py; \
fi

pip3 install pyyaml==6.0.1 pyxb-x==1.2.6.1 numpy==1.25.2 pyxb pypmml dill==0.3.7 hyperopt==0.2.5 tensorflow==2.10 pandas==2.0.3 scipy==1.11.2 grpcio==1.57.0 protobuf==3.19.4 scikit-learn==1.3.0 xgboost==1.7.6 mock

dropdb madlib || echo $?
createdb madlib || echo $?

pushd "$HOME/src/madlib"
./configure -Wno-dev
make -j$(nproc) EP_boost
make -j$(nproc) EP_eigen
make -j$(nproc) install
rm -rf "$HOME/src/madlib/build/src/ports/greenplum/6/extension" "$HOME/src/madlib/build/src/ports/greenplum/7/extension"
make -j$(nproc) extension-install
psql -d madlib -c "create extension if not exists  plpython3u"
psql -d madlib -c "create schema if not exists madlib"
psql -d madlib -c "create extension if not exists madlib schema madlib"
rm -rf "$DATADIRS/madlib"
mkdir -p "$DATADIRS/madlib"
#/usr/local/madlib/Current/madpack/madpack.py -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l install
exit
/usr/local/madlib/Current/madpack/madpack.py -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l install-check
/usr/local/madlib/Current/madpack/madpack.py -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l dev-check
/usr/local/madlib/Current/madpack/madpack.py -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l unit-test
popd
