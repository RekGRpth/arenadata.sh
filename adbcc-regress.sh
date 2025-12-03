#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/adbcc-regress.log")

#(
export PGOPTIONS="-c optimizer=off"
pushd "$HOME/src/adbcc/adcc-extension/regress"
rm -f expected
if [[ "$GP_MAJOR" == "6c" || "$GP_MAJOR" == "6" ]]; then
    ln -fs expected6 expected
elif [[ "$GP_MAJOR" == "7c" || "$GP_MAJOR" == "7" || "$GP_MAJOR" == "8" ]]; then
    ln -fs expected7 expected
fi
sudo chmod -R 777 /sys/fs/cgroup/{memory,cpu,cpuset}
sudo mkdir -p /sys/fs/cgroup/{memory,cpu,cpuset}/gpdb
sudo chmod -R 777 /sys/fs/cgroup/{memory,cpu,cpuset}/gpdb
sudo chown -R $USER:$GROUP /sys/fs/cgroup/{memory,cpu,cpuset}/gpdb
#gpconfig -c gp_resource_manager -v group
#gpconfig -r gp_resource_manager
#gpstop -afr
#make -j"$(nproc)" installcheck
#exit
#/home/.local$GP_MAJOR/lib/postgresql/pgxs/src/makefiles/../../src/test/regress/pg_regress --load-extension=plpythonu --load-extension=socket --load-extension=gp_inject_fault cdb_dispatch_replace_ccnt
#/usr/local/lib/postgresql/pgxs/src/makefiles/../../src/test/regress/pg_regress --load-extension=plpythonu --load-extension=socket --load-extension=gp_inject_fault cdb_dispatch_replace_ccnt
#/usr/local/lib/postgresql/pgxs/src/makefiles/../../src/test/regress/pg_regress --load-extension=plpythonu --load-extension=socket --load-extension=gp_inject_fault errors
#/usr/local/lib/postgresql/pgxs/src/makefiles/../../src/test/regress/pg_regress --load-extension=plpythonu --load-extension=gp_inject_fault errors
#/usr/local/lib/postgresql/pgxs/src/makefiles/../../src/test/regress/pg_regress --load-extension=plpythonu --load-extension=socket --load-extension=gp_inject_fault node_status
#"$HOME/gpdb_src/src/test/isolation2/pg_isolation2_regress" --load-extension=plpythonu --load-extension=gp_inject_fault node_metric
#/usr/local/lib/postgresql/pgxs/src/makefiles/../../src/test/regress/pg_regress --load-extension=plpythonu --load-extension=socket create_extension socket node_status
#"$HOME/gpdb_src/src/test/regress/pg_regress" --load-extension=plpythonu --load-extension=socket create_extension socket node_status
"$HOME/gpdb_src/src/test/regress/pg_regress" --load-extension=plpython3u --load-extension=socket create_extension node_slice
#"$HOME/gpdb_src/src/test/regress/pg_regress" --load-extension=plpythonu --load-extension=socket create_extension cdb_dispatch_replace_ccnt
#"$HOME/gpdb_src/src/test/regress/pg_regress" --load-extension=plpythonu --load-extension=socket create_extension zstd_compression
#"$HOME/gpdb_src/src/test/regress/pg_regress" --load-extension=plpython3u --load-extension=socket create_extension ccnt_threshold
#"$HOME/gpdb_src/src/test/regress/pg_regress" --load-extension=plpythonu --load-extension=socket create_extension bfv_interconnect
#"$HOME/gpdb_src/src/test/regress/pg_regress" --load-extension=plpythonu --load-extension=socket create_extension bfv_interconnect cdb_dispatch_ccnt errors errors_resgroup inner_queries misc
#"$HOME/gpdb_src/src/test/regress/pg_regress" --load-extension=plpython3u --load-extension=socket create_extension socket spill_snapshot
#"$HOME/gpdb_src/src/test/regress/pg_regress" --load-extension=plpython3u --load-extension=socket create_extension spill_snapshot
#"$HOME/gpdb_src/src/test/regress/pg_regress" --load-extension=plpython3u --load-extension=socket create_extension failure_in_txn failure_in_txn_2 failure_in_txn_gc failure_ssid failure_ssid_gc deparse_context
#"$HOME/gpdb_src/src/test/regress/pg_regress" --load-extension=plpythonu --load-extension=socket create_extension failure_in_txn failure_in_txn_2 failure_in_txn_resgroup errors errors_resgroup
#"$HOME/gpdb_src/src/test/regress/pg_regress" --load-extension=plpythonu --load-extension=socket create_extension failure_in_txn failure_in_txn_2 errors
#"$HOME/gpdb_src/src/test/regress/pg_regress" --load-extension=plpython3u --load-extension=socket create_extension explain errors
#) 2>&1 | tee "$HOME/adbcc-regress.log"
popd
