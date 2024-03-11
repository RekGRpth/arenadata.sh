#!/bin/sh -eux

(
#export CFLAGS="-O0 -g3"
cd "$HOME/src/gpdb$GP_MAJOR"
CONFIGURE_FLAGS=
if [ "$GP_MAJOR" -eq "5" ]; then
    sudo rpm -i https://ci.arenadata.io/artifactory/ADB/6.7.1_arenadata4/centos/7/community/x86_64/sigar-1.6.5-163.el7.x86_64.rpm || echo $?
    sudo rpm -i https://ci.arenadata.io/artifactory/ADB/6.7.1_arenadata4/centos/7/community/x86_64/sigar-headers-1.6.5-163.el7.x86_64.rpm || echo $?
#    CONFIGURE_FLAGS="--with-gssapi --enable-debug --enable-depend --enable-cassert --with-libraries=bin_orca/lib --with-includes=bin_orca/include"
#    CONFIGURE_FLAGS="--with-libraries=$HOME/.local$GP_MAJOR/lib"
    CONFIGURE_FLAGS="--with-libraries=$GPHOME/lib --with-includes=$GPHOME/include"
    export LD_LIBRARY_PATH="$GPHOME/lib"
fi
#export CONFIGURE_FLAGS="--enable-debug-extensions --with-gssapi --enable-cassert --enable-debug --enable-depend"
#source "$HOME/src/gpdb$GP_MAJOR/concourse/scripts/common.bash"
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
    --enable-gpperfmon \
    --enable-mapreduce \
    --enable-orafce \
    --enable-tap-tests \
    --prefix=$GPHOME \
    --with-libxml \
    --with-libxslt \
    --with-openssl \
    --with-perl \
    --with-python \
    --with-uuid=e2fs \
    --with-wal-segsize=64 \
    $CONFIGURE_FLAGS
) 2>&1 | tee "$HOME/config.log"
