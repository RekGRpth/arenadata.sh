#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR/contrib/dummy_seclabel"
make -j"$(nproc)" install
cd "$HOME/src/gpbackup"
gpconfig -c shared_preload_libraries -v dummy_seclabel
gpstop -afr
#make -j"$(nproc)" test
#make -j"$(nproc)" unit
#make -j"$(nproc)" integration
#make -j"$(nproc)" end_to_end
export CUSTOM_BACKUP_DIR="/tmp"
export GINKGO_FLAGS="-r --keep-going --randomize-suites --randomize-all --no-color --vv"
ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "restores from --exclude filtered incremental backup with partition tables"
) 2>&1 | tee "$HOME/gpbackup-test.log"
