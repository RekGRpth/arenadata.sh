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

if [ "$GP_MAJOR" -eq "6" ]; then
    if [ -n "${PYTHON3:-}" ]; then
        export PYTHON="$PYTHON3"
        make -C src/pl/plpython clean
        #pushd ${GPDB_SRC_PATH}
        ./config.status --recheck
        make -C src/pl/plpython install
        #popd
    fi
fi
#cd "$HOME/src/gpdb$GP_MAJOR/gpcontrib/gp_internal_tools"
#make -j"$(nproc)" install
gpstop -afr
) 2>&1 | tee "$HOME/build.log"
#-exec handle SIGINT nostop
#-exec handle SIGINT pass
