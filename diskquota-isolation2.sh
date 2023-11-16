#!/bin/sh -eux

(
createdb contrib_regression || echo $?
cd "$HOME/src/gpdb$GP_MAJOR/src/test/isolation2"
make -j$(nproc) install
cd "$HOME/src/diskquota/tests/isolation2"
"$HOME/src/gpdb$GP_MAJOR/src/test/isolation2/pg_isolation2_regress" --init-file=../init_file config test_truncate reset_config
) 2>&1 | tee "$HOME/diskquota-isolation2.log"
