#!/bin/bash -eux

(
killall cat || echo $?
killall gpbackup_helper || echo $?
rm -rf "$HOME/gpAdminLogs/"*.log
#dropuser testrole || echo $?
dropdb --if-exists test
dropdb --if-exists testdb
dropdb --if-exists restoredb
dropuser --if-exists testrole
#psql -c "drop user if exists testrole"
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
#ginkgo -r --keep-going --randomize-suites --randomize-all --no-color --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir "/tmp" 2>&1
export CUSTOM_BACKUP_DIR="$HOME/gpbackup"
export GINKGO_FLAGS="-r --keep-going --randomize-suites --randomize-all --no-color --poll-progress-after=0s --v --trace"
#export GINKGO_FLAGS="-r --keep-going --randomize-suites --randomize-all --no-color --poll-progress-after=0s -vv"
#export TEST_GPDB_VERSION=6.999.0
#export TEST_GPDB_VERSION="$GP_MAJOR.999.0"
if [[ "$GP_MAJOR" == "6c" || "$GP_MAJOR" == "6u" ]]; then
    export TEST_GPDB_VERSION="6.999.0"
elif [[ "$GP_MAJOR" == "7c" || "$GP_MAJOR" == "7u" ]]; then
    export TEST_GPDB_VERSION="7.999.0"
fi
#export GINKGO_FLAGS="-r --keep-going --randomize-suites --randomize-all --no-color -vv"
#export GINKGO_FLAGS="-r --keep-going --no-color --v"
#export GINKGO_FLAGS="-r --keep-going --no-color -vv"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "restores from --exclude filtered incremental backup with partition tables"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "panics if given a leaf partition table and --leaf-partition-data is not set"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and gprestore with leaf-partition-data and exclude-table root partition backup flags"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and gprestore with leaf-partition-data and exclude-table leaf partition backup flags"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and gprestore without leaf-partition-data and with exclude-table root partition backup flags"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and gprestore with leaf-partition-data and exclude-table root partition backup flags"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and gprestore with leaf-partition-data and exclude-table leaf partition backup flags"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Can backup a 7-segment cluster and restore to current cluster"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gprestore with jobs flag and postdata has metadata"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Restore to a different-sized cluster"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Signal handler tests"
#ginkgo $GINKGO_FLAGS --timeout=1m --poll-progress-after=0s integration -- --ginkgo.focus "gpbackup_helper will not error out when plugin writes something to stderr with cluster resize"
#ginkgo $GINKGO_FLAGS --timeout=1m --poll-progress-after=0s integration -- --ginkgo.focus "gpbackup_helper will error out if plugin exits early with cluster resize"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Can backup a 2-segment cluster and restore to current cluster with incremental backups and a single data file with copy-queue-size"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Can backup a 2-segment cluster and restore to current cluster with incremental backups and a single data file"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and gprestore with with-stats flag"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Extensions dependency"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Restore from various-sized clusters with a replicated table"
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
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Running gprestore without the --timestamp flag"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Running gprestore without the --timestamp flag" --ginkgo.focus "Will not hang if gpbackup and gprestore runs with single-data-file and the helper goes down at its start"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "errors out if there are no backups in a user-provided backup directory" --ginkgo.focus "Will not hang if gpbackup and gprestore runs with single-data-file and the helper goes down at its start"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "errors out if there are no backups in a user-provided backup directory"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup with --without-globals and --metadata-only"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Restores table data distributed by multi-key enum"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Restores table data distributed by altered enum type"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Restores table data partitioned using GPDB7 partition syntax"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and gprestore with single-data-file flag without compression"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and gprestore on database with all objects with copy-queue-size"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "backup empty db with statistics"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and gprestore with --with-globals and --create-db"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and gprestore with --with-globals"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Can backup a 1-segment cluster and restore to current cluster with a filter"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup with --without-globals and --metadata-only"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and gprestore on database with all objects"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Restores table data distributed by an enum"
#ginkgo $GINKGO_FLAGS --timeout=40m --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gprestore with copy-queue-size and sends a SIGTERM to ensure cleanup functions successfully"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup with copy-queue-size and sends a SIGTERM to ensure cleanup functions successfully"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and sends a SIGINT to ensure blocked LOCK TABLE query is canceled"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "restores from a incremental backup specified with a backup directory"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "checks access privileges for multiple users on a column"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and gprestore with include-table-file restore flag"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s utils -- --ginkgo.focus "StartGpbackupHelpers"
#ginkgo $GINKGO_FLAGS --timeout=10s --poll-progress-after=0s integration -- --ginkgo.focus "runs restore gpbackup_helper with gzip compression with plugin"
#ginkgo $GINKGO_FLAGS --timeout=1m --poll-progress-after=0s integration -- --ginkgo.focus "restore tests"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "does not hold lock on gp_segment_configuration when backup is in progress"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and gprestore with the data-only restore flag"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and sends a SIGTERM to ensure cleanup functions successfully"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "SIGTERM"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Will clean up segments helper processes after error during restore"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Will not hang after error during restore"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Will not hang after error during restore with jobs"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and gprestore with leaf-partition-data and backupDir flags"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and gprestore with exclude-table-file restore flag"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Will not hang if gprestore runs with cluster resize and the helper goes down on one of the tables"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Will continue after error during restore with jobs"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and gprestore with with-stats flag and single-backup-dir"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and gprestore to backup functions depending on table row's type"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and gprestore on database with all objects"
#ginkgo $GINKGO_FLAGS --timeout=10m --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gprestore with copy-queue-size and sends a SIGTERM to ensure cleanup functions successfully" --ginkgo.focus "runs gpbackup and gprestore on database with all objects"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gprestore with --redirect-schema restoring data and statistics to the new schema"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Redirect Schema"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Can backup a 2-segment cluster and restore to current cluster single data file" --ginkgo.focus "Can backup a 7-segment cluster and restore to current cluster with a filter" --ginkgo.focus "runs gprestore with --redirect-schema restoring data and statistics to the new schema"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Restore to a different-sized cluster" --ginkgo.focus "Redirect Schema"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Will not hang after error during single data file restore"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Will not start next batch after error during resize single data file restore"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Will fatal error after helper error on resize-restore"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Will not hang and fatal error after helper error on resize-restore with jobs"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Will not hang if gpbackup runs with single-data-file and copy-queue-size and the helper goes down at its start"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Will error after helper fatal error on resize-restore"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Will not hang and error after helper fatal error on resize-restore with jobs"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Will not hang and fatal error after helper error on resize-restore with jobs"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Can backup 7-segment cluster and continue to resize restore to current cluster if table already exists with incompatible column type"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Can backup a 9-segment cluster and restore to current cluster with single data file"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Properly handles enum type as distribution or partition key"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Properly hanldes user defined type if different schema used"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "restores table with enum when exporting statistics"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "constructs dependencies correctly for a function dependent on an implicit array type"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s backup -- --ginkgo.focus "PrintStatisticsStatementsForTable"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "PrintStatisticsStatementsForTable"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "type dependencies"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "PrintCreateBaseTypeStatement"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Exclude subpartitions for given root partition in leaf-partition-data mode"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "correctly maps oids to parent or leaf table types"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "PrintRegularTableCreateStatement"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "creates a one-level partition table"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "creates a two-level partition table"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "creates a GPDB 7"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration --
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "returns a slice for a base type with"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "correctly errors if a piped copy command fails"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "Tables order cases, when there is a partitioned table to backup"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "Wrappers Integration"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "GetPartitionTableMap"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "BackupDataForAllTables"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "Tables order cases, when there is a partitioned table to backup" --ginkgo.focus "Tables order cases, when there is an AO/CO table to backup"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "Tables order cases, when there is an AO/CO table to backup"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "Tables order when no filtering is used or tables filtering is defined"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "RetrieveAndProcessTables"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "Tables order when schema filtering is defined"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "Tables order when schema filtering is defined"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "RetrieveAndProcessTables" --ginkgo.focus "Tables order when no filtering is used or tables filtering is defined"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "returns the data tables in descending order of their sizes (relpages) when include-tables(-file) flag is used"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "gpbackup_helper will not error out when plugin writes something to stderr"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "gpbackup_helper will not error out when plugin writes something to stderr" --ginkgo.focus "gpbackup_helper will error out if plugin exits early"
#ginkgo $GINKGO_FLAGS --timeout=1m --poll-progress-after=0s integration -- --ginkgo.focus "Skips batches if skip file is discovered with"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s helper -- --ginkgo.focus "Check subset flag"
ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s helper -- --ginkgo.focus "doRestoreAgent Mocked unit tests"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "gpbackup_helper will error out if plugin exits early"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "gpbackup_helper will error out if plugin exits early with cluster resize"
#ginkgo $GINKGO_FLAGS --timeout=10m --poll-progress-after=0s integration -- --ginkgo.focus "gpbackup_helper end to end integration tests"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s restore -- --ginkgo.focus "verifies backup file counts match on all segments with resize-cluster"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s restore -- --ginkgo.focus "will output expected error string from COPY ON SEGMENT failure"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s restore -- --ginkgo.focus "will restore a table from"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s backup -- --ginkgo.focus "will back up a table to a single file"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s backup -- --ginkgo.focus "backs up a single regular table with single data file"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s utils -- --ginkgo.focus "generates the correct rsync commands to copy oid file to segments"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s utils -- --ginkgo.focus "constructs the correct ssh call to check for the existance of an error file on each segment"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s restore -- --ginkgo.focus "will restore a table from a single data file"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s restore -- --ginkgo.focus "will restore a table from its own file with gzip compression"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s restore -- --ginkgo.focus "will restore a table from its own file without compression"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s restore -- --ginkgo.focus "will restore a table from its own file with zstd compression"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s restore -- --ginkgo.focus "will restore a table from its own file with zstd compression using a plugin"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s backup -- --ginkgo.focus "SplitTablesByPartitionType"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s restore -- --ginkgo.focus "CopyTableIn"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s restore -- --ginkgo.focus "CopyTableIn with resize restore from 4 to 3 segments"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s backup -- --ginkgo.focus "prints a GRANT statement on a table column"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s backup -- --ginkgo.focus "GetAllViews properly handles NULL view definitions"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s backup -- --ginkgo.focus "backup/statistics tests"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s backup -- --ginkgo.focus "prints both an ALTER TABLE ... OWNER TO statement and comments"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "checks access privileges for multiple users on a column"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and gprestore with single-data-file flag with copy-queue-size"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Will not hang on error with plugin during resize-restore and on-error-continue"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Will not hang on error with plugin during resize-restore and on-error-continue" --ginkgo.focus "Does not restore tables excluded by user if user input is provided"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and gprestore with plugin, single-data-file, and copy-queue-size"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and gprestore with include-table-file restore flag with a single data with copy-queue-size"
#ginkgo $GINKGO_FLAGS --timeout=10s --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and gprestore with include-schema restore flag with a single data file with copy-queue-size"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Restores from an incremental backup based on a from-timestamp incremental with --copy-queue-size"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs example_plugin.bash with plugin_test"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and gprestore with single-data-file flag without compression with copy-queue-size"
#ginkgo $GINKGO_FLAGS --timeout=1m --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "runs gpbackup and gprestore with plugin, single-data-file, no-compression, and copy-queue-size"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Will not hang if gpbackup and gprestore runs with single-data-file and the helper goes down at its start" --ginkgo.focus "Will not hang if gprestore runs with cluster resize and the helper goes down on one of the tables"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Will not hang if gpbackup and gprestore runs with single-data-file and the helper goes down at its start"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Will not hang if gprestore runs with cluster resize and the helper goes down on one of the tables"
#ginkgo $GINKGO_FLAGS --timeout=5s --poll-progress-after=0s integration -- --ginkgo.focus "Generates error file when backup agent interrupted"
#ginkgo $GINKGO_FLAGS --timeout=5s --poll-progress-after=0s integration -- --ginkgo.focus "Generates error file when restore agent interrupted"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "prints column level privileges"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "returns table attribute information for a heap table"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "GetAttributeStatistics"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "GetTupleStatistics"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "GetColumnDefinitions"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "runs backup gpbackup_helper with" --ginkgo.focus "runs restore gpbackup_helper with" --ginkgo.focus "gpbackup_helper will not error out when plugin" --ginkgo.focus "Continues restore process when encountering an error"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s integration -- --ginkgo.focus "backup tests"
#ginkgo $GINKGO_FLAGS --timeout=1m --poll-progress-after=0s integration -- --ginkgo.focus "runs restore gpbackup_helper without compression with plugin"
#ginkgo $GINKGO_FLAGS --timeout=1m --poll-progress-after=0s integration -- --ginkgo.focus "runs restore gpbackup_helper without compression"
#ginkgo $GINKGO_FLAGS --timeout=1m --poll-progress-after=0s integration -- --ginkgo.focus "Continues restore process when encountering an error with flag --on-error-continue"
#ginkgo $GINKGO_FLAGS --timeout=1m --poll-progress-after=0s integration -- --ginkgo.focus "prints attribute and tuple statistics for a table with dropped column"
#ginkgo $GINKGO_FLAGS --timeout=1m --poll-progress-after=0s integration -- --ginkgo.focus "gpbackup_helper will not error out when plugin writes something to stderr with cluster resize" --ginkgo.focus "runs restore gpbackup_helper with gzip compression" --ginkgo.focus "Generates error file when restore agent interrupted" --ginkgo.focus "runs restore gpbackup_helper without compression with plugin" --ginkgo.focus "runs restore gpbackup_helper with zstd compression with plugin" --ginkgo.focus "runs restore gpbackup_helper with gzip compression with plugin"
#ginkgo $GINKGO_FLAGS --timeout=1m --poll-progress-after=0s integration -- --ginkgo.focus "runs restore gpbackup_helper with zstd compression with plugin"
#ginkgo $GINKGO_FLAGS --timeout=3h --poll-progress-after=0s end_to_end -- --custom_backup_dir $CUSTOM_BACKUP_DIR --ginkgo.focus "Exclude subpartitions for given root partition in leaf-partition-data mode" --ginkgo.focus "End to End incremental tests Incremental restore No DDL no partitioning Include/Exclude schemas and tables"
#make depend build install integration end_to_end
) 2>&1 | tee "$HOME/gpbackup-test.log"
