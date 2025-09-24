#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/madlib$GP_MAJOR.log")

#PIP=pip3
if [[ "$GP_MAJOR" == "6" ]]; then
    export PYTHONPATH=/opt/adb6-python3.9/lib/python3.9/dist-packages
    export PATH=/opt/adb6-python3.9/bin:$PATH
#    export PATH=/opt/adb6-python3.9/bin/:$PATH
#    export PYTHONPATH=/usr/local/lib/python3.9/dist-packages
#    PIP="python3 /opt/adb6-python3.9/bin/pip3"
#    PIP="python3 /usr/local/bin/pip3"
fi
#$PIP 
pip3 install pyyaml==6.0.1 pyxb-x==1.2.6.1 numpy==1.25.2 pyxb pypmml dill==0.3.7 hyperopt==0.2.5 tensorflow==2.10 pandas==2.0.3 scipy==1.11.2 grpcio==1.57.0 protobuf==3.19.4 scikit-learn==1.3.0 xgboost==1.7.6 mock

dropdb madlib || echo $?
createdb madlib || echo $?

pushd "$HOME/src/madlib"
./configure
make -j$(nproc) install
make -j$(nproc) extension-install
psql -d madlib -c "create extension if not exists  plpython3u"
psql -d madlib -c "create schema if not exists madlib"
psql -d madlib -c "create extension if not exists madlib schema madlib"
rm -rf "$DATADIRS/madlib"
mkdir -p "$DATADIRS/madlib"
#export PYTHONPATH=
test -f "$GPHOME/greenplum_path.sh" && source "$GPHOME/greenplum_path.sh"
test -f "$GPHOME/greengage_path.sh" && source "$GPHOME/greengage_path.sh"
#/usr/local/madlib/bin/madpack -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l install
/usr/local/madlib/bin/madpack -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l install-check
/usr/local/madlib/bin/madpack -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l dev-check
/usr/local/madlib/bin/madpack -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l unit-test
popd
