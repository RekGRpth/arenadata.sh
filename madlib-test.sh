#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/madlib$GP_MAJOR-test.log")

if ! which pip3; then
    curl https://bootstrap.pypa.io/pip/get-pip.py -o get-pip.py; \
    python3 get-pip.py; \
    rm get-pip.py; \
fi

pip3 install \
    dill==0.3.7 \
    grpcio==1.57.0 \
    hyperopt==0.2.5 \
    mock \
    numpy==1.25.2 \
    pandas==2.0.3 \
    protobuf==3.19.4 \
    pypmml \
    pyxb \
    pyxb-x==1.2.6.1 \
    pyyaml==6.0.1 \
    scikit-learn==1.3.0 \
    scipy==1.11.2 \
    tensorflow==2.10 \
    xgboost==1.7.6

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
