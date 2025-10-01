#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/madlib$GP_MAJOR.log")

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

dropdb madlib || echo $?
createdb madlib || echo $?

rm -rf "$HOME/src/madlib/build/src/ports/greenplum/6/extension" "$HOME/src/madlib/build/src/ports/greenplum/7/extension"

pushd "$HOME/src/madlib"
./configure -Wno-dev
make -j$(nproc) extension-install
popd

psql -d madlib -c "create extension if not exists  plpython3u"
psql -d madlib -c "create schema if not exists madlib"
psql -d madlib -c "create extension if not exists madlib schema madlib"
