#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR/src/test/isolation2"
make -j$(nproc) clean
make -j$(nproc) install
#cd "$HOME/src/adbcc"
#cd "$HOME/src/adbcc/adcc-extension/isolation2"
#export ISOLATION2_ROOT="$HOME/src/gpdb$GP_MAJOR/src/test/isolation2"
#make -j"$(nproc)" -C adcc-extension installcheck-isolation2
#make -j"$(nproc)" installcheck
#/home/.local$GP_MAJOR/lib/postgresql/pgxs/src/makefiles/../../src/test/regress/pg_regress --load-extension=plpythonu --load-extension=socket --load-extension=gp_inject_fault cdb_dispatch_replace_ccnt
#/usr/local/lib/postgresql/pgxs/src/makefiles/../../src/test/regress/pg_regress --load-extension=plpythonu --load-extension=socket --load-extension=gp_inject_fault cdb_dispatch_replace_ccnt
#/usr/local/lib/postgresql/pgxs/src/makefiles/../../src/test/regress/pg_regress --load-extension=plpythonu --load-extension=socket --load-extension=gp_inject_fault errors
#/usr/local/lib/postgresql/pgxs/src/makefiles/../../src/test/regress/pg_regress --load-extension=plpythonu --load-extension=gp_inject_fault errors
#"$HOME/src/gpdb$GP_MAJOR/src/test/isolation2/pg_isolation2_regress" --load-extension=plpythonu --load-extension=gp_inject_fault --init-file=./init_file_adcc node_metric
#"$HOME/src/gpdb$GP_MAJOR/src/test/isolation2/pg_isolation2_regress" --load-extension=plpythonu --load-extension=gp_inject_fault --init-file=./init_file_adcc node_metric
#cd "$HOME/src/gpdb$GP_MAJOR/src/test/isolation2"
./pg_isolation2_regress  --init-file="$HOME/src/adbcc/adcc-extension/isolation2/init_file_adcc" --inputdir="$HOME/src/adbcc/adcc-extension/isolation2" --outputdir="$HOME/src/adbcc/adcc-extension/isolation2" --load-extension=gp_inject_fault --load-extension=plpythonu node_metric
) 2>&1 | tee "$HOME/adbcc-isolation2.log"
