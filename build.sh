#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/build.log")
#(
#export COPT="${COPT:-} -fno-omit-frame-pointer -Wno-maybe-uninitialized"
#if [ "$GP_MAJOR" -ne "7" ]; then
#    cd "$HOME/src/gpdb$GP_MAJOR/gpMgmt/bin"
#    make pygresql
#    #make psutil
#fi
pushd "$HOME/src/gpdb$GP_MAJOR"
    #make -j"$(nproc)" clean
    make -j"$(nproc)" install
    if [[ "$GP_MAJOR" == "6u" ]]; then
        if [ -n "${PYTHON3:-}" ]; then
            export PYTHON="$PYTHON3"
            make -C src/pl/plpython clean
            #pushd ${GPDB_SRC_PATH}
            ./config.status --recheck
            make -C src/pl/plpython install
            #popd
        fi
    fi
    pushd "$HOME/src/gpdb$GP_MAJOR/src/test/regress"
        make -j$(nproc) install
    popd
    pushd "$HOME/src/gpdb$GP_MAJOR/src/test/isolation"
        make -j$(nproc) install
    popd
    if [[ "$GP_MAJOR" != "9u" ]]; then
        pushd "$HOME/src/gpdb$GP_MAJOR/src/test/isolation2"
            make -j$(nproc) install
        popd
        pushd "$HOME/src/gpdb$GP_MAJOR/src/test/regress"
            make -j$(nproc) twophase_pqexecparams
            make -j$(nproc) tablespace-setup
            if [[ "$GP_MAJOR" == "6c" || "$GP_MAJOR" == "6u" ]]; then
                make -j$(nproc) file_monitor
            elif [[ "$GP_MAJOR" == "7c" || "$GP_MAJOR" == "7u" || "$GP_MAJOR" == "8u" ]]; then
                pushd "$HOME/src/gpdb$GP_MAJOR/contrib/spi"
                make -j$(nproc) install
                popd
            fi
        popd
    fi
popd
#cd "$HOME/src/gpdb$GP_MAJOR/gpcontrib/gp_internal_tools"
#make -j"$(nproc)" install
#gpconfig -c gp_log_stack_trace_lines -v true --skipvalidation
#gpconfig -c log_duration -v on --skipvalidation
#gpconfig -c gp_log_stack_trace_lines -v false --skipvalidation
gpstop -afr
#) 2>&1 | tee "$HOME/build.log"
#-exec handle SIGINT nostop
#-exec handle SIGINT pass
