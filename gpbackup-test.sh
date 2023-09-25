#!/bin/sh -eux

(
#cd "$HOME/src/gpdb$GP_MAJOR/contrib/dummy_seclabel"
#make -j"$(nproc)" install
cd "$HOME/src/gpbackup"
#gpconfig -c shared_preload_libraries -v dummy_seclabel
#gpstop -afr
#make -j"$(nproc)" test
#make -j"$(nproc)" unit
#make -j"$(nproc)" integration
#make -j"$(nproc)" end_to_end
#make -j"$(nproc)" lint
export CUSTOM_BACKUP_DIR="$HOME/gpbackup"
export GINKGO_FLAGS="-r --keep-going --randomize-suites --randomize-all --no-color --v"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "restores from --exclude filtered incremental backup with partition tables"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "panics if given a leaf partition table and --leaf-partition-data is not set"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Exclude subpartitions for given root partition in leaf-partition-data mode"
ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Can backup a 7-segment cluster and restore to current cluster"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Can backup a 2-segment cluster and restore to current cluster"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s restore -- --ginkgo.focus "verifies backup file counts match on all segments with resize-cluster"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s restore -- --ginkgo.focus "verifies backup file counts match on all segments with resize-cluster"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Exclude subpartitions for given root partition in leaf-partition-data mode" --ginkgo.focus "End to End incremental tests Incremental restore No DDL no partitioning Include/Exclude schemas and tables"
) 2>&1 | tee "$HOME/gpbackup-test.log"
