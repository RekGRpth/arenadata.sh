#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/dist.log")

export CONFIGURE_FLAGS="--enable-debug-extensions --with-gssapi --enable-cassert --enable-debug --enable-depend"
export CFLAGS="-O0 -ggdb -g3 -fno-omit-frame-pointer -Wclobbered"
export CXXFLAGS="-DGPOS_DEBUG -O0 -ggdb -g3 -fno-omit-frame-pointer -Wclobbered"

pushd "$HOME/gpdb_src"
#export GPROOT="$HOME/gpdb_src/build/usr/lib"
#export GPDIR=gpdb
make -C gpAux GPROOT=/usr/local PARALLEL_MAKE_OPTS=-j"$(nproc)" -s dist
popd
