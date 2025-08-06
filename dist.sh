#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/dist.log")

pushd "$HOME/src/gpdb$GP_MAJOR"
export GPROOT="$HOME/src/gpdb$GP_MAJOR/build/usr/lib"
export GPDIR=gpdb
make -C gpAux dist
popd
