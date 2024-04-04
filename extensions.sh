#!/bin/sh -eux

(
#export PGOPTIONS="-c optimizer=off"
cd "$HOME/src/gpdb$GP_MAJOR/src/test/modules/test_extensions"
make -j"$(nproc)" install
"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --init-file="$HOME/src/gpdb$GP_MAJOR/src/test/regress/init_file" test_extensions
) 2>&1 | tee "$HOME/extensions.log"
