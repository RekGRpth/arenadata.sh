#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/pg_upgrade.log")

export PGOPTIONS="-c optimizer=off"

#unset COORDINATOR_DATA_DIRECTORY
#unset DATADIRS
#unset MASTER_DATA_DIRECTORY
#unset PGPORT
#unset PORT_BASE
#unset PGDATA
#unset SEGMENT_0_DATA_DIRECTORY
#unset SEGMENT_1_DATA_DIRECTORY
#unset SEGMENT_2_DATA_DIRECTORY
#unset STANDBY_DATA_DIRECTORY
#unset MIRROR_0_DATA_DIRECTORY
#unset MIRROR_1_DATA_DIRECTORY
#unset MIRROR_2_DATA_DIRECTORY

#ln -fs "$DATADIRS" "$HOME/gpdb_src/gpAux/gpdemo/datadirs"
mkdir -p "$HOME/gpdb_src/gpAux/gpdemo/datadirs"
export DATADIRS="$HOME/gpdb_src/gpAux/gpdemo/datadirs"
export PGDATA="$DATADIRS/qddir/demoDataDir-1"

if [[ "$GP_MAJOR" == "6" ]]; then
    export MASTER_DATA_DIRECTORY="$PGDATA"
else
    export COORDINATOR_DATA_DIRECTORY="$PGDATA"
fi

export MIRROR_0_DATA_DIRECTORY="$DATADIRS/dbfast_mirror1/demoDataDir0"
export MIRROR_1_DATA_DIRECTORY="$DATADIRS/dbfast_mirror2/demoDataDir1"
export MIRROR_2_DATA_DIRECTORY="$DATADIRS/dbfast_mirror3/demoDataDir2"
export SEGMENT_0_DATA_DIRECTORY="$DATADIRS/dbfast1/demoDataDir0"
export SEGMENT_1_DATA_DIRECTORY="$DATADIRS/dbfast2/demoDataDir1"
export SEGMENT_2_DATA_DIRECTORY="$DATADIRS/dbfast3/demoDataDir2"
export STANDBY_DATA_DIRECTORY="$DATADIRS/standby"

pushd "$HOME/gpdb_src"
rm -rf /tmp/.s.PGSQL.*
make create-demo-cluster
createdb --owner="$USER" regression
popd
pushd "$HOME/gpdb_src/src/bin/pg_upgrade"
#make -j"$(nproc)" install
make -j"$(nproc)" check
popd
