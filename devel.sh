#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/devel.log")

export CONFIGURE_FLAGS="--enable-debug-extensions --with-gssapi --enable-cassert --enable-debug --enable-depend"
export CFLAGS="-O0 -ggdb -g3 -fno-omit-frame-pointer -Wclobbered"
export CXXFLAGS="-DGPOS_DEBUG -O0 -ggdb -g3 -fno-omit-frame-pointer -Wclobbered"

pushd "$HOME/src/gpdb$GP_MAJOR"
#export GPROOT="$HOME/src/gpdb$GP_MAJOR/build/usr/lib"
#export GPDIR=gpdb
make -C gpAux GPROOT=/usr/local PARALLEL_MAKE_OPTS=-j"$(nproc)" -s devel
popd
