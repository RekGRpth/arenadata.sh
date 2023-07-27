#!/bin/sh -eux

(
#test -f "$HOME/data$GP_MAJOR/qddir/demoDataDir-1/postmaster.pid" && test -f "/tmp/.s.PGSQL.${GP_MAJOR}432" &&  
gpstop -af || echo $?
rm -rf /tmp/.s.PGSQL.* "$HOME/.ssh/known_hosts"
rm -rf "$HOME/data$GP_MAJOR/*"
cd "$HOME/src/gpdb$GP_MAJOR"
make create-demo-cluster

#cd "$HOME/src/gpdb$GP_MAJOR/src/test/isolation2"
#make -j$(nproc) install
#./pg_isolation2_regress  --init-file=../../../src/test/regress/init_file --init-file=./init_file_isolation2 setup uao_crash_compaction_column
) 2>&1 | tee "$HOME/demo.log"
