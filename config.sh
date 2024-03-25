#!/bin/sh -eux

(
#export CFLAGS="-O0 -g3"
cd "$HOME/src/gpdb$GP_MAJOR"
CONFIGURE_FLAGS=
if [ "$GP_MAJOR" -eq "5" ]; then
    sudo rpm -i --replacepkgs https://ci.arenadata.io/artifactory/ADB/6.7.1_arenadata4/centos/7/community/x86_64/sigar-1.6.5-163.el7.x86_64.rpm
    sudo rpm -i --replacepkgs https://ci.arenadata.io/artifactory/ADB/6.7.1_arenadata4/centos/7/community/x86_64/sigar-headers-1.6.5-163.el7.x86_64.rpm
#    CONFIGURE_FLAGS="--with-gssapi --enable-debug --enable-depend --enable-cassert --with-libraries=bin_orca/lib --with-includes=bin_orca/include"
#    CONFIGURE_FLAGS="--with-libraries=$HOME/.local$GP_MAJOR/lib"
    CONFIGURE_FLAGS="--with-libraries=$GPHOME/lib --with-includes=$GPHOME/include"
    export LD_LIBRARY_PATH="$GPHOME/lib"
#elif [ "$GP_MAJOR" -eq "6" ]; then
#    sudo rpm -i --replacepkgs https://downloads.adsw.io/ADB/6.22.0_arenadata38/centos/7/community/x86_64/sigar-1.6.5-1056.git2932df5.el7.x86_64.rpm
#    sudo rpm -i --replacepkgs http://downloads.adsw.io/ADB/6.22.0_arenadata38/centos/7/community/x86_64/sigar-headers-1.6.5-1056.git2932df5.el7.x86_64.rpm
fi
#export CONFIGURE_FLAGS="--enable-debug-extensions --with-gssapi --enable-cassert --enable-debug --enable-depend"
#source "$HOME/src/gpdb$GP_MAJOR/concourse/scripts/common.bash"
#export enable_debug_extensions=set
#    LDFLAGS="-Wl,--enable-new-dtags -Wl,-rpath,\$/../lib" \
./configure \
    CFLAGS="-O0 -ggdb -g3 -fno-omit-frame-pointer" \
    CXXFLAGS="-DGPOS_DEBUG -O0 -ggdb -g3 -fno-omit-frame-pointer" \
    LIBS="-llber" \
    --disable-rpath \
    --enable-cassert \
    --enable-debug \
    --enable-debug-extensions \
    --enable-depend \
    --enable-gpcloud \
    --enable-gpperfmon \
    --enable-ic-proxy \
    --enable-mapreduce \
    --enable-orafce \
    --enable-orca \
    --prefix=$GPHOME \
    --with-gssapi \
    --with-gssapi \
    --with-ldap \
    --with-libxml \
    --with-libxslt \
    --with-llvm \
    --with-openssl \
    --with-pam \
    --with-perl \
    --with-python \
    --with-pythonsrc-ext \
    --with-uuid=e2fs \
    $CONFIGURE_FLAGS
) 2>&1 | tee "$HOME/config.log"
