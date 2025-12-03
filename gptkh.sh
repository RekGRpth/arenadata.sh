#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/gptkh.log")

export PGOPTIONS='-c optimizer=off'

pushd "$HOME/src/pxf/fdw"
make -j"$(nproc)" install
popd
pushd "$HOME/src/gptkh"
#git submodule update --init --remote
PG_CFLAGS="-I/$HOME/src/pxf/fdw" make -j"$(nproc)" install
#) 2>&1 | tee "$HOME/gptkh.log"
#pushd "$HOME/src/gptkh/docker"
#docker compose up -d
#popd
PYTHONPATH=/usr/lib/python3/dist-packages
#sudo usermod -aG docker "${USER}"
docker/setup.sh
make -j"$(nproc)" installcheck
make -j"$(nproc)" installcheck-ch installcheck-pxf
docker/clean.sh
#pushd "$HOME/src/gptkh/docker"
#docker compose rm -f -s -v
#popd
popd
