#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/credcheck.log")
pushd "$HOME/src/credcheck"
make -j"$(nproc)" clean
make -j"$(nproc)" install
#gpconfig -c shared_preload_libraries -v "$(psql -At -c "SELECT array_to_string(array_append(string_to_array(current_setting('shared_preload_libraries'), ','), 'credcheck'), ',')" postgres)"
#gpstop -afr
make -j"$(nproc)" installcheck
popd
