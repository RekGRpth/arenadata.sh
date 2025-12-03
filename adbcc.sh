#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/adbcc.log")

if [[ "$GP_MAJOR" == "6" ]]; then
    pip install --no-cache-dir \
        grpcio-tools \
        protobuf
    pip3 install --no-cache-dir \
        protobuf==3.20.0
fi

pushd "$HOME/src/adbcc"
git submodule update --init --recursive
#popd
#pushd "$HOME/src/adbcc/adcc-extension"
make -C adcc-extension -j"$(nproc)" clean
make -C adcc-extension -j"$(nproc)"
make -C adcc-extension -j"$(nproc)" install
#popd
#pushd "$HOME/src/adbcc/adcc-extension/test/socket"
make -C adcc-extension/test/socket -j"$(nproc)" clean
make -C adcc-extension/test/socket -j"$(nproc)"
make -C adcc-extension/test/socket -j"$(nproc)" install
popd
#gpconfig -c shared_preload_libraries -v 'gpadcc'
gpconfig -c shared_preload_libraries -v "$(psql -At -c "SELECT array_to_string(array_append(string_to_array(current_setting('shared_preload_libraries'), ','), 'gpadcc'), ',')" postgres)"
gpconfig -c gp_enable_query_metrics -v on
psql -d postgres -c "CREATE EXTENSION IF NOT EXISTS gpadcc"
gpstop -afr
#gpconfig -c adcc.send_buffer_size -v 10485760;
gpconfig -c adcc.monitor_inner_queries -v on
gpconfig -c adcc.monitor_utility_inner_queries -v on
gpstop -u
#) 2>&1 | tee "$HOME/adbcc.log"
#popd
