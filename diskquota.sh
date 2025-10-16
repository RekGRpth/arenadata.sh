#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/diskquota.log")

pushd "$HOME/src/diskquota"
rm -rf build
mkdir -p build
cd build
#make -j"$(nproc)" clean
cmake .. -DCMAKE_BUILD_TYPE= -DDISKQUOTA_DDL_CHANGE_CHECK=off
#cmake --build .
make -j"$(nproc)" install
gpconfig -r log_min_messages
#gpconfig -c shared_preload_libraries -v diskquota-2.2
#gpconfig -c shared_preload_libraries -v "$(../tests/data/current_binary_name)"
gpconfig -c shared_preload_libraries -v "$(psql -At -c "SELECT array_to_string(array_append(string_to_array(regexp_replace(current_setting('shared_preload_libraries'), '(,{0,1})diskquota(.*)\.so', ''), ','), '$(../tests/data/current_binary_name)'), ',')" postgres)"
#gpconfig -c diskquota.naptime -v 2147483 --skipvalidation
#gpconfig -c diskquota.max_table_segments -v 104857600 --skipvalidation
#gpconfig -c diskquota.max_active_tables -v 1048576 --skipvalidation
createdb diskquota || echo $?
gpstop -afr
#) 2>&1 | tee "$HOME/diskquota.log"
popd
