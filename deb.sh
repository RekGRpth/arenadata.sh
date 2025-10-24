#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/deb.log")

sudo apt install -y build-essential devscripts debhelper dh-python ccache ninja-build python-pip
pushd "$HOME/gpdb_src"
rm -rf build
unset CONFIGURE_FLAGS
#export GPROOT="$HOME/gpdb_src/build/usr/lib"
#export GGROOT=/usr/local
#export GPDIR=gpdb
#make -C gpAux PARALLEL_MAKE_OPTS=-j$(nproc) pkg-deb GGROOT=/usr/local
make -C gpAux PARALLEL_MAKE_OPTS=-j$(nproc) pkg-deb
popd
