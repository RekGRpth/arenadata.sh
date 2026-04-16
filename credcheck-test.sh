#!/bin/bash -eux

export PGOPTIONS="-c optimizer=off"

exec 2>&1 &> >(tee "$HOME/credcheck-test.log")
pushd "$HOME/gpdb_src/gpcontrib/credcheck"
make -j"$(nproc)" installcheck
exit
pushd "$HOME/gpdb_src/gpcontrib/credcheck/test"
"$HOME/gpdb_src/src/test/regress/pg_regress" --load-extension=credcheck 09_banned_role
popd
