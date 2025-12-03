#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/pxf-test.log")

#(
pushd "$HOME/src/pxf/external-table"
make -j"$(nproc)" install
make -j"$(nproc)" installcheck
popd
pushd "$HOME/src/pxf/fdw"
make -j"$(nproc)" install
make -j"$(nproc)" installcheck
popd
exit
pushd "$HOME/src/pxf/regression"
#make -j"$(nproc)" FDW_FilterPushDownTest
make -j"$(nproc)" FilterPushDownTest
#go mod init
#go mod init github.com/golang/dep/cmd/dep
#go mod init github.com/onsi/ginkgo/ginkgo
#make -j"$(nproc)" clean
#go install github.com/golang/dep/cmd/dep@latest
#go install github.com/onsi/ginkgo/ginkgo@latest
#make -j"$(nproc)" external-table
#make -j"$(nproc)" fdw
#make -j"$(nproc)" cli
#make -j"$(nproc)" install-server
#git apply "$(dirname "$0")/notest.diff"
#make -j"$(nproc)" install
#git apply "$(dirname "$0")/notest-revert.diff"
#mkdir -p "$PXF_BASE"
#pxf restart
#) 2>&1 | tee "$HOME/pxf-test.log"
popd
