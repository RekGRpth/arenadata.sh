#!/bin/sh -eux

(
cd "$HOME/src/adbcc/adcc-extension"
#make -j"$(nproc)" installcheck
#/home/.local$GP_MAJOR/lib/postgresql/pgxs/src/makefiles/../../src/test/regress/pg_regress --load-extension=plpythonu --load-extension=socket --load-extension=gp_inject_fault cdb_dispatch_replace_ccnt
/usr/local/lib/postgresql/pgxs/src/makefiles/../../src/test/regress/pg_regress --load-extension=plpythonu --load-extension=socket --load-extension=gp_inject_fault cdb_dispatch_replace_ccnt
) 2>&1 | tee "$HOME/adbcc-test.log"
