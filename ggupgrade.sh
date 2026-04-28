#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/ggupgrade.log")

mkdir -p /usr/local/go/bin
pushd "$HOME/src/ggupgrade"
make -j"$(nproc)" install-dependencies
make -j"$(nproc)" generate
#make -j"$(nproc)" clean
#make -j"$(nproc)" build
make -j"$(nproc)" install
#make -j"$(nproc)" lint
make -j"$(nproc)" unit
#make -j"$(nproc)" integration
#make -j"$(nproc)" acceptance
#make -j"$(nproc)" pg-upgrade-tests
#make -j"$(nproc)" pipeline
#make -j"$(nproc)" functional-pipeline
popd
