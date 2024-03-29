#!/bin/sh -eux

(
#dropuser testrole || echo $?
dropdb --if-exists restoredb
dropuser --if-exists testrole
rm "$DATADIRS"/*/*/gpbackup_* || echo $?
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
export TEST_GPDB_VERSION=6.999.0
#export GINKGO_FLAGS="-r --keep-going --randomize-suites --randomize-all --no-color -vv"
#export GINKGO_FLAGS="-r --keep-going --no-color --v"
#export GINKGO_FLAGS="-r --keep-going --no-color -vv"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "restores from --exclude filtered incremental backup with partition tables"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "panics if given a leaf partition table and --leaf-partition-data is not set"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Exclude subpartitions for given root partition in leaf-partition-data mode"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Can backup a 7-segment cluster and restore to current cluster"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Restore to a different-sized cluster"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and gprestore with with-stats flag"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Extensions dependency"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "End to End incremental tests Incremental restore No DDL no partitioning Existing tables in existing schemas were updated"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "End to End incremental tests Incremental restore No DDL no partitioning Include/Exclude schemas and tables"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Extensions dependency" --ginkgo.focus "End to End incremental tests Incremental restore No DDL no partitioning Existing tables in existing schemas were updated" --ginkgo.focus "End to End incremental tests Incremental restore No DDL no partitioning Include/Exclude schemas and tables"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Extensions dependency" --ginkgo.focus "End to End incremental tests Incremental restore No DDL no partitioning Include/Exclude schemas and tables"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Extensions dependency" --ginkgo.focus "Restores only tables included by use if user input is provided"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Extensions dependency" --ginkgo.focus "End to End incremental tests Incremental restore No DDL no partitioning Existing tables in existing schemas were updated"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "End to End incremental tests Incremental restore No DDL no partitioning Existing tables in existing schemas were updated" --ginkgo.focus "End to End incremental tests Incremental restore No DDL no partitioning Include/Exclude schemas and tables"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "restores statistics for leaf partitions when leaf-partition-data flag was specified with backup when runs gprestore with with-stats flag"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Can backup a 2-segment cluster and restore to current cluster"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Can backup a 9-segment cluster and restore to current cluster"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Can backup a 9-segment cluster and restore to current cluster"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Restore to a different-sized cluster"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Can backup a 9-segment cluster and restore to current cluster with replicated tables"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and gprestore with with-stats flag and single-backup-dir"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "Tables order cases, when there is a partitioned table to backup"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "Wrappers Integration"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "BackupDataForAllTables"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "Tables order cases, when there is a partitioned table to backup" --ginkgo.focus "Tables order cases, when there is an AO/CO table to backup"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "Tables order cases, when there is an AO/CO table to backup"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "Tables order when no filtering is used or tables filtering is defined"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "RetrieveAndProcessTables"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "Tables order when schema filtering is defined"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "Tables order when schema filtering is defined"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "RetrieveAndProcessTables" --ginkgo.focus "Tables order when no filtering is used or tables filtering is defined"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "returns the data tables in descending order of their sizes (relpages) when include-tables(-file) flag is used"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "runs restore gpbackup_helper with gzip compression with plugin"
ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "StartGpbackupHelpers"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s restore -- --ginkgo.focus "verifies backup file counts match on all segments with resize-cluster"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s restore -- --ginkgo.focus "verifies backup file counts match on all segments with resize-cluster"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Exclude subpartitions for given root partition in leaf-partition-data mode" --ginkgo.focus "End to End incremental tests Incremental restore No DDL no partitioning Include/Exclude schemas and tables"
#TEST_GPDB_VERSION=6.999.0 ginkgo $GINKGO_FLAGS backup/ filepath/ history/ helper/ options/ report/ restore/ toc/ utils/ testutils/
#TEST_GPDB_VERSION=7.999.0 ginkgo $GINKGO_FLAGS backup/ filepath/ history/ helper/ options/ report/ restore/ toc/ utils/ testutils/
#export TEST_GPDB_VERSION="$(echo "$(psql postgres -c "select version();")" | sed -n 's/.*Greenplum Database \([0-9].[0-9]\+.[0-9]\+\).*/\1/p')"
#ginkgo $GINKGO_FLAGS backup/ filepath/ history/ helper/ options/ report/ restore/ toc/ utils/ testutils/
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s backup -- --ginkgo.focus "PrintCreateMaterializedViewStatement"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s backup -- --ginkgo.focus "can print a view with privileges, an owner, and a comment"
) 2>&1 | tee "$HOME/gpbackup-unit.log"
