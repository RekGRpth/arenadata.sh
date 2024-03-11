#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR/src/backend/gporca"
#rm -rf "$HOME/src/gpdb$GP_MAJOR/src/backend/gporca/build"
cmake -GNinja -H. -Bbuild -D CMAKE_BUILD_TYPE=RelWithDebInfo
#cmake -GNinja -H. -Bbuild -D CMAKE_BUILD_TYPE=Debug
cd "$HOME/src/gpdb$GP_MAJOR/src/backend/gporca/build"
ninja -j"$(nproc)"
#server/gporca_test -U CAntiSemiJoinTest
#server/gporca_test -U CICGTest
#server/gporca_test -U CConstTblGetTest
#server/gporca_test -U CTVFTest
#server/gporca_test -d ../data/dxl/minidump/LeftOuter2InnerUnionAllAntiSemiJoin-Tpcds.mdp
#server/gporca_test -d ../data/dxl/minidump/Negative-IndexApply1.mdp
#server/gporca_test -d ../data/dxl/minidump/OneSegmentGather.mdp
#server/gporca_test -d ../data/dxl/minidump/CTEMisAlignedProducerConsumer.mdp
ctest -j"$(nproc)" --rerun-failed --output-on-failure | tee "$HOME/src/gpdb$GP_MAJOR/failures.out"
python ../scripts/fix_mdps.py --logFile "$HOME/src/gpdb$GP_MAJOR/failures.out"
) 2>&1 | tee "$HOME/unit.log"
#xmllint --format $MASTER_DATA_DIRECTORY/minidumps/Minidump_20221229_123038_9_15.mdp > ~/src/gpdb$GP_MAJOR/src/backend/gporca/data/dxl/minidump/CTE1Replicated.mdp
