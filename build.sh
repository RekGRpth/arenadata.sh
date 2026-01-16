#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/build.log")
#(
#export COPT="${COPT:-} -fno-omit-frame-pointer -Wno-maybe-uninitialized"
#if [ "$GP_MAJOR" -ne "7" ]; then
#    cd "$HOME/gpdb_src/gpMgmt/bin"
#    make pygresql
#    #make psutil
#fi
killall -9 gpmmon || echo $?
killall -9 gpsmon || echo $?
pushd "$HOME/gpdb_src"
    #make -j"$(nproc)" clean
    make -j"$(nproc)" install
    if [[ "$GP_MAJOR" == "6" ]]; then
        if [ -n "${PYTHON3:-}" ]; then
            export PYTHON="$PYTHON3"
            make -C src/pl/plpython clean
            #pushd ${GPDB_SRC_PATH}
            ./config.status --recheck
            make -C src/pl/plpython install
            #popd
        fi
    fi
popd
#cd "$HOME/gpdb_src/gpcontrib/gp_internal_tools"
#make -j"$(nproc)" install
#gpconfig -c gp_log_stack_trace_lines -v true --skipvalidation
#gpconfig -c log_duration -v on --skipvalidation
#gpconfig -c gp_log_stack_trace_lines -v false --skipvalidation
gpstop -afr
#) 2>&1 | tee "$HOME/build.log"
#-exec handle SIGINT nostop
#-exec handle SIGINT pass
