#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/isolation.log")

pushd "$HOME/gpdb_src/src/test/isolation"

#(
#export PGOPTIONS="-c optimizer=on"
export PGOPTIONS="-c optimizer=off"
#cd "$HOME/gpdb_src/src/test/isolation"
#make -j$(nproc) installcheck -i
#exit
#make -j$(nproc) clean
#make -j$(nproc) install
#make -j$(nproc) install pg_isolation_regress gpstringsubs.pl gpdiff.pl isolationtester
#./pg_isolation_regress  --init-file=../../../src/test/regress/init_file --init-file=./init_file --load-extension=gp_inject_fault intra-grant-inplace
#./pg_isolation_regress  --init-file=../../../src/test/regress/init_file --init-file=./init_file --load-extension=gp_inject_fault vacuum-full-permissions
#./pg_isolation_regress  --init-file=../../../src/test/regress/init_file --init-file=./init_file --load-extension=gp_inject_fault async-notify
#./pg_isolation_regress  --init-file=../../../src/test/regress/init_file --init-file=./init_file --load-extension=gp_inject_fault predicate-lock-hot-tuple deadlock-parallel
./pg_isolation_regress  --init-file=../../../src/test/regress/init_file --init-file=./init_file --load-extension=gp_inject_fault ao-insert-eof
#./pg_isolation_regress  --init-file=../../../src/test/regress/init_file --init-file=./init_file --load-extension=gp_inject_fault inplace-inval
#./pg_isolation_regress  --init-file=../../../src/test/regress/init_file --init-file=./init_file --load-extension=gp_inject_fault eval-plan-qual
#./pg_isolation_regress  --init-file=../../../src/test/regress/init_file --init-file=./init_file --load-extension=gp_inject_fault eval-plan-qual-trigger
#) 2>&1 | tee "$HOME/isolation.log"
popd
