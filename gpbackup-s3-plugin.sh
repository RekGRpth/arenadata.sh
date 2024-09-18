#!/bin/sh -eux

(
cd "$HOME/src/gpbackup-s3-plugin"
#make -j"$(nproc)" clean
#go mod download
#go mod tidy
#go mod download github.com/onsi/ginkgo
#go mod tidy
#go get go.sum
#go install github.com/onsi/ginkgo
#go install github.com/onsi/ginkgo/v2/ginkgo@v2.8.4
#go mod tidy
#go mod slices
make -j"$(nproc)" depend
make -j"$(nproc)" build
make -j"$(nproc)" install
make -j"$(nproc)" test
#mkdir -p "$HOME/go/src/github.com/greenplum-db"
#ln -fs "../../../../src/gpbackup" "$HOME/go/src/github.com/greenplum-db/"
#cd "$HOME/src/gpdb$GP_MAJOR/contrib/dummy_seclabel"
#make -j"$(nproc)" install
#gpconfig -c shared_preload_libraries -v dummy_seclabel
#gpstop -afr
) 2>&1 | tee "$HOME/gpbackup-s3-plugin.log"
