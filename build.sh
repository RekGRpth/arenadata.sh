#!/bin/sh -eux

(
#export COPT="${COPT:-} -fno-omit-frame-pointer -Wno-maybe-uninitialized"
#if [ "$GP_MAJOR" -ne "5" ]; then
    cd "$HOME/src/gpdb$GP_MAJOR/gpMgmt/bin"
    make pygresql
    #make psutil
#fi
cd "$HOME/src/gpdb$GP_MAJOR"
make -j"$(nproc)" install
#cd "$HOME/src/gpdb$GP_MAJOR/gpcontrib/gp_internal_tools"
#make -j"$(nproc)" install
gpstop -afr
) 2>&1 | tee "$HOME/build.log"
