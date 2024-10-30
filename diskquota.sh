#!/bin/sh -eux

(
cd "$HOME/src/diskquota"
rm -rf build
mkdir -p build
cd build
#make -j"$(nproc)" clean
cmake .. -DDISKQUOTA_DDL_CHANGE_CHECK=off
make -j"$(nproc)" install
#gpconfig -c shared_preload_libraries -v diskquota-2.2
gpconfig -c shared_preload_libraries -v "$(../tests/data/current_binary_name)"
#gpconfig -c diskquota.naptime -v 2147483 --skipvalidation
#gpconfig -c diskquota.max_table_segments -v 104857600 --skipvalidation
#gpconfig -c diskquota.max_active_tables -v 1048576 --skipvalidation
createdb diskquota || echo $?
gpstop -afr
) 2>&1 | tee "$HOME/diskquota.log"
