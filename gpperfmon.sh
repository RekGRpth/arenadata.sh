#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/gpperfmon.log")

#(
pushd "$HOME/gpdb_src/gpAux/gpperfmon"
make -j$(nproc) clean
#rm /usr/local/bin/gpmmon /usr/local/bin/gpsmon
dropdb --if-exists gpperfmon
make -j$(nproc) install
#gpperfmon_install --port $PGPORT --enable --password password --verbose
gpperfmon_install --port $PGPORT --enable --verbose
gpstop -afr
#) 2>&1 | tee "$HOME/gpperfmon.log"
popd
