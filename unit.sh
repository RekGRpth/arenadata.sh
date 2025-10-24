#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/unit.log")

#rm -rf "$HOME/gpdb_src/src/backend/gporca/build"

pushd "$HOME/gpdb_src/src/backend/gporca"
cmake -GNinja -H. -Bbuild -D CMAKE_BUILD_TYPE=RelWithDebInfo
#cmake -GNinja -H. -Bbuild -D CMAKE_BUILD_TYPE=Debug
pushd "$HOME/gpdb_src/src/backend/gporca/build"
ninja -j"$(nproc)"
#server/gporca_test -U CAntiSemiJoinTest
#server/gporca_test -U CICGTest
#server/gporca_test -U CConstTblGetTest
#server/gporca_test -U CTVFTest
#server/gporca_test -d ../data/dxl/minidump/LeftOuter2InnerUnionAllAntiSemiJoin-Tpcds.mdp
#server/gporca_test -d ../data/dxl/minidump/Negative-IndexApply1.mdp
#server/gporca_test -d ../data/dxl/minidump/CTEvolatile.mdp
#exit
#server/gporca_test -d ../data/dxl/minidump/CTEMisAlignedProducerConsumer.mdp
ctest -j"$(nproc)" --rerun-failed --output-on-failure | tee "$HOME/gpdb_src/failures.out"
python3 ../scripts/fix_mdps.py --logFile "$HOME/gpdb_src/failures.out"
#../scripts/fix_mdps.py --logFile "$HOME/gpdb_src/failures.out"
#) 2>&1 | tee "$HOME/unit.log"
#xmllint --format $MASTER_DATA_DIRECTORY/minidumps/Minidump_20221229_123038_9_15.mdp > ~/gpdb_src/src/backend/gporca/data/dxl/minidump/CTE1Replicated.mdp
popd
popd
