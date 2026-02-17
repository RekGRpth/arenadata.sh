#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/madlib$GP_MAJOR-test.log")

which pip3 || curl https://bootstrap.pypa.io/pip/get-pip.py | python3

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
    pyyaml \
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
#"$HOME/madlib-test.log" "$HOME/madlib-test.xml"
mkdir -p "$DATADIRS/madlib"
export PATH="$PATH:/usr/local/madlib/bin"
#shopt -s lastpipe
#status=0
#exit_code=0
#(
#madpack -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l dev-check -t pmml/pmml
#madpack -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l dev-check -t pmml/pmml_rf
#madpack -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l dev-check -t pmml/pmml_check_fields
#madpack -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l dev-check -t dbscan
#madpack -p greenplum -c /madlib -d "$DATADIRS/madlib" -l install-check -t array_ops
#madpack -c /madlib -d "$DATADIRS/madlib" -l install-check -t array_ops
#madpack -p greenplum -c /madlib -d "$DATADIRS/madlib" -l install-check -t pmml
#exit
#madpack -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l install
#madpack -p greenplum -c /madlib -d /tmp install-check
#madpack -p greenplum -c /madlib -d /tmp install-check | tee -a "$HOME/madlib-test.log"
#madpack -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l install-check
madpack -p greengage -v -c /madlib -d "$DATADIRS/madlib" -l install-check
#madpack -p greengage -v -c /madlib -d "$DATADIRS/madlib" -l dev-check
#madpack -p greengage -v -c /madlib -d "$DATADIRS/madlib" -l unit-test
#madpack -p greenplum -v -c /madlib -d "$DATADIRS/madlib" -l unit-test
#madpack -p greenplum -v -d "$DATADIRS/madlib" -l unit-test
#python3 "$HOME/src/madlib/tool/jenkins/report.py" "" "$HOME/madlib-test.log" "/dev/stderr"
#junit "$HOME/madlib-test.xml"
#) | tee /dev/fd/1 | grep "Check the log at" | sed -r "s|.+Check the log at (.+)|\1|" | while read -r name; do status=1; cat "$name"; done
#) | tee /dev/fd/2 | grep -q "Check the log at" && exit 1
#) | tee /dev/stderr | grep -q "Check the log at" && status=1
#) | tee /dev/stderr | grep -q "Check the log at" && status=1
#) | tee /dev/stderr | grep -q "|FAIL|" && status=1 || status=0
#) | tee /dev/stderr | { grep -q "|FAIL|" && test "$?" = 0; }
#echo "anything" | { grep e || test $? = 1; } | { grep e2 || test $? = 1; }
#) | tee /dev/stderr | grep -q "|FAIL|" || exit_code="$?"
#) | tee /dev/stderr | { exit_code=$?; grep -q "|FAIL|" && exit 1 || exit $exit_code; }
#) | tee /dev/stderr | { exit_code=$?; grep -q "|FAIL|" && exit_code=1 || exit_code=$exit_code; }
#) | tee /dev/stderr | { export exit_code=$?; grep -q "|FAIL|" && export exit_code=1 || export exit_code=$exit_code; }
#) | tee /dev/stderr | awk '"|FAIL|" ~ $0 { fail=1; next } END { if (fail) { exit 1 }}'
#) | tee /dev/stderr | awk '"|FAIL|" ~ $0 { fail=1 } END { if (fail) { exit 1 }}'
#) | awk '{ print($0) } $0 ~ /: ERROR :/ { fail=1 } END { if (fail) { exit 1 }}'
#) | tee /dev/stderr | exit_code=$? && grep -q "|FAIL|" && exit_code=1
#if [[ $exit_code -ne 1 ]]; then
#exit $exit_code
#fi
echo "$?"
#exit "$(( $? + $status ))"
