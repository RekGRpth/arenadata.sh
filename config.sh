#!/bin/sh -eux

(
#export CFLAGS="-O0 -g3"
cd "$HOME/src/gpdb$GP_MAJOR"
CONFIGURE_FLAGS=
if [ "$GP_MAJOR" -eq "5" ]; then
#    CONFIGURE_FLAGS="--with-gssapi --enable-debug --enable-depend --enable-cassert --with-libraries=bin_orca/lib --with-includes=bin_orca/include"
    CONFIGURE_FLAGS="--with-libraries=$HOME/.local$GP_MAJOR/lib"
fi
export enable_debug_extensions=set
./configure \
    CFLAGS="-O0 -ggdb -g3 -fno-omit-frame-pointer" \
    CXXFLAGS="-DGPOS_DEBUG -O0 -ggdb -g3 -fno-omit-frame-pointer" \
    --disable-gpcloud \
    --disable-rpath \
    --enable-cassert \
    --enable-debug \
    --enable-debug-extensions \
    --enable-depend \
    --enable-mapreduce \
    --enable-orafce \
    --enable-tap-tests \
    --prefix="$HOME/.local$GP_MAJOR" \
    --with-libxml \
    --with-libxslt \
    --with-openssl \
    --with-perl \
    --with-python \
    --with-uuid=e2fs \
    --with-wal-segsize=16 \
    $CONFIGURE_FLAGS
) 2>&1 | tee "$HOME/config.log"
