#!/bin/bash -eux

(
#export PGOPTIONS="-c optimizer=off"
cd "$HOME/src/adbcc/adcc-extension/regress"
if [[ "$GP_MAJOR" == "6c" || "$GP_MAJOR" == "6u" ]]; then
    ln -fs expected6/ "$HOME/src/adbcc/adcc-extension/regress/expected"
elif [[ "$GP_MAJOR" == "7c" || "$GP_MAJOR" == "7u" ]]; then
    ln -fs expected7/ "$HOME/src/adbcc/adcc-extension/regress/expected"
fi
sudo chmod -R 777 /sys/fs/cgroup/{memory,cpu,cpuset}
sudo mkdir -p /sys/fs/cgroup/{memory,cpu,cpuset}/gpdb
sudo chmod -R 777 /sys/fs/cgroup/{memory,cpu,cpuset}/gpdb
sudo chown -R $USER:$GROUP /sys/fs/cgroup/{memory,cpu,cpuset}/gpdb
gpconfig -c gp_resource_manager -v group
gpstop -afr
#make -j"$(nproc)" installcheck
#/home/.local$GP_MAJOR/lib/postgresql/pgxs/src/makefiles/../../src/test/regress/pg_regress --load-extension=plpythonu --load-extension=socket --load-extension=gp_inject_fault cdb_dispatch_replace_ccnt
#/usr/local/lib/postgresql/pgxs/src/makefiles/../../src/test/regress/pg_regress --load-extension=plpythonu --load-extension=socket --load-extension=gp_inject_fault cdb_dispatch_replace_ccnt
#/usr/local/lib/postgresql/pgxs/src/makefiles/../../src/test/regress/pg_regress --load-extension=plpythonu --load-extension=socket --load-extension=gp_inject_fault errors
#/usr/local/lib/postgresql/pgxs/src/makefiles/../../src/test/regress/pg_regress --load-extension=plpythonu --load-extension=gp_inject_fault errors
#/usr/local/lib/postgresql/pgxs/src/makefiles/../../src/test/regress/pg_regress --load-extension=plpythonu --load-extension=socket --load-extension=gp_inject_fault node_status
#"$HOME/src/gpdb$GP_MAJOR/src/test/isolation2/pg_isolation2_regress" --load-extension=plpythonu --load-extension=gp_inject_fault node_metric
#/usr/local/lib/postgresql/pgxs/src/makefiles/../../src/test/regress/pg_regress --load-extension=plpythonu --load-extension=socket create_extension socket node_status
#"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --load-extension=plpythonu --load-extension=socket create_extension socket node_status
#"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --load-extension=plpythonu --load-extension=socket create_extension node_slice
#"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --load-extension=plpythonu --load-extension=socket create_extension cdb_dispatch_replace_ccnt
#"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --load-extension=plpythonu --load-extension=socket create_extension zstd_compression
#"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --load-extension=plpython3u --load-extension=socket create_extension ccnt_threshold
#"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --load-extension=plpythonu --load-extension=socket create_extension bfv_interconnect
#"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --load-extension=plpythonu --load-extension=socket create_extension bfv_interconnect cdb_dispatch_ccnt errors errors_resgroup inner_queries misc
#"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --load-extension=plpython3u --load-extension=socket create_extension socket spill_snapshot
"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --load-extension=plpython3u --load-extension=socket create_extension spill_snapshot
#"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --load-extension=plpythonu --load-extension=socket create_extension failure_in_txn failure_in_txn_2 failure_in_txn_resgroup errors errors_resgroup
#"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --load-extension=plpythonu --load-extension=socket create_extension failure_in_txn failure_in_txn_2 errors
) 2>&1 | tee "$HOME/adbcc-regress.log"
