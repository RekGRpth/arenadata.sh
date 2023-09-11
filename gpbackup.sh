#!/bin/sh -eux

(
cd "$HOME/src/gpbackup"
#make -j"$(nproc)" clean
go mod download
go mod tidy
go mod download github.com/onsi/ginkgo
go mod tidy
#go get go.sum
#go install github.com/onsi/ginkgo
go install github.com/onsi/ginkgo/v2/ginkgo@v2.8.4
go mod tidy
make -j"$(nproc)" depend
make -j"$(nproc)" build
make -j"$(nproc)" install
mkdir -p "$HOME/go/src/github.com/greenplum-db"
ln -fs "../../../../src/gpbackup" "$HOME/go/src/github.com/greenplum-db/"
) 2>&1 | tee "$HOME/gpbackup.log"
