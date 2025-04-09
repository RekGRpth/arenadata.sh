#!/bin/sh -eux

(
export PGOPTIONS="-c optimizer=on"
#export PGOPTIONS="-c optimizer=off"
cd "$HOME/src/gpdb$GP_MAJOR/src/test/isolation"
#make -j$(nproc) installcheck -i
#make -j$(nproc) clean
make -j$(nproc) install gpstringsubs.pl gpdiff.pl
./pg_isolation_regress  --init-file=../../../src/test/regress/init_file --init-file=./init_file --load-extension=gp_inject_fault intra-grant-inplace
#./pg_isolation_regress  --init-file=../../../src/test/regress/init_file --init-file=./init_file --load-extension=gp_inject_fault eval-plan-qual
#./pg_isolation_regress  --init-file=../../../src/test/regress/init_file --init-file=./init_file --load-extension=gp_inject_fault eval-plan-qual-trigger
) 2>&1 | tee "$HOME/isolation.log"
