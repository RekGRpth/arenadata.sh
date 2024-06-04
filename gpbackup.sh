#!/bin/sh -eux

(
killall cat || echo $?
killall gpbackup_helper || echo $?
cd "$HOME/src/gpbackup"
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
mkdir -p "$HOME/go/src/github.com/greenplum-db"
ln -fs "../../../../src/gpbackup" "$HOME/go/src/github.com/greenplum-db/"
#cd "$HOME/src/gpdb$GP_MAJOR/contrib/dummy_seclabel"
#make -j"$(nproc)" install
#gpconfig -c shared_preload_libraries -v dummy_seclabel
#gpstop -afr
find "$DATADIRS" -name "gpbackup_*_script_*" -o -name "gpbackup_*_pipe_*" -o -name "gpbackup_*_skip_*" -o -name "gpbackup_*_oid_*" | while read name; do rm "$name"; done
) 2>&1 | tee "$HOME/gpbackup.log"
#PATH=~/docker/gpdb/.opt/go/bin:$PATH GOPATH=~/docker/gpdb/.go go get github.com/itchyny/json2yaml
