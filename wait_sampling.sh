#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/gg_wait_sampling.log")

pushd "$HOME/gpdb_src/gpcontrib/gg_wait_sampling/isolation2"

export PGOPTIONS="-c optimizer=on"
export PGOPTIONS="-c optimizer=off"
make -j$(nproc) installcheck -i
sudo chmod -R 777 /sys/fs/cgroup/{memory,cpu,cpuset}
sudo mkdir -p /sys/fs/cgroup/{memory,cpu,cpuset}/gpdb
sudo chmod -R 777 /sys/fs/cgroup/{memory,cpu,cpuset}/gpdb
sudo chown -R $USER:$GROUP /sys/fs/cgroup/{memory,cpu,cpuset}/gpdb
make -j$(nproc) installcheck-resgroup -i
exit
popd
