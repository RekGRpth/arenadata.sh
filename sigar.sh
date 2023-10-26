#!/bin/sh -eux

(
cd "$HOME/src/sigar"
#mkdir -p build
#cd build
#CMAKE_INSTALL_PREFIX=/usr/local/sigar cmake ..
./autogen.sh
./configure
#./configure --prefix="$HOME/.local$GP_MAJOR"
make -j$(nproc) install
) 2>&1 | tee "$HOME/sigar.log"
#gpperfmon_install --port $PGPORT --enable --password password --verbose
