#!/bin/sh -eux

(
#export COPT="${COPT:-} -fno-omit-frame-pointer -Wno-maybe-uninitialized"
#if [ "$GP_MAJOR" -ne "7" ]; then
#    cd "$HOME/src/gpdb$GP_MAJOR/gpMgmt/bin"
#    make pygresql
#    #make psutil
#fi
cd "$HOME/src/gpdb$GP_MAJOR"
#make -j"$(nproc)" clean
make -j"$(nproc)" install
#cd "$HOME/src/gpdb$GP_MAJOR/gpcontrib/gp_internal_tools"
#make -j"$(nproc)" install
gpstop -afr
) 2>&1 | tee "$HOME/build.log"
#-exec handle SIGINT nostop
#-exec handle SIGINT pass
