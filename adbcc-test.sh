#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/adbcc-test.log")

#(
sudo chmod -R 777 /sys/fs/cgroup/{memory,cpu,cpuset}
sudo mkdir -p /sys/fs/cgroup/{memory,cpu,cpuset}/gpdb
sudo chmod -R 777 /sys/fs/cgroup/{memory,cpu,cpuset}/gpdb
sudo chown -R $USER:$GROUP /sys/fs/cgroup/{memory,cpu,cpuset}/gpdb
#gpconfig -c gp_resource_manager -v group
#gpconfig -r gp_resource_manager
#gpstop -afr
pushd "$HOME/src/adbcc/adcc-extension"
export ISOLATION2_ROOT="$HOME/src/gpdb$GP_MAJOR/src/test/isolation2"
export PGOPTIONS="-c optimizer=off"
export PGOPTIONS="-c optimizer_enable_table_alias=off"
make installcheck installcheck-isolation2
#) 2>&1 | tee "$HOME/adbcc-isolation2.log"
popd
