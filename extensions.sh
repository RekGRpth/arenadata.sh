#!/bin/sh -eux

(
#export PGOPTIONS="-c optimizer=off"
cd "$HOME/gpdb_src/src/test/modules/test_extensions"
make -j"$(nproc)" install
"$HOME/gpdb_src/src/test/regress/pg_regress" --init-file="$HOME/gpdb_src/src/test/regress/init_file" test_extensions
) 2>&1 | tee "$HOME/extensions.log"
