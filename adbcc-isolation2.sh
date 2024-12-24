#!/bin/bash -eux

(
export PGOPTIONS="-c optimizer=off"
cd "$HOME/src/adbcc/adcc-extension/isolation2"
rm -f expected
if [[ "$GP_MAJOR" == "6c" || "$GP_MAJOR" == "6u" ]]; then
    ln -fs expected6 expected
elif [[ "$GP_MAJOR" == "7c" || "$GP_MAJOR" == "7u" ]]; then
    ln -fs expected7 expected
fi
cd "$HOME/src/gpdb$GP_MAJOR/src/test/isolation2"
make -j$(nproc) clean
make -j$(nproc) install
#if [[ "$GP_MAJOR" == "6c" || "$GP_MAJOR" == "6u" ]]; then
#    ln -fs expected6/ "$HOME/src/adbcc/adcc-extension/isolation2/expected"
#elif [[ "$GP_MAJOR" == "7c" || "$GP_MAJOR" == "7u" ]]; then
#    ln -fs expected7/ "$HOME/src/adbcc/adcc-extension/isolation2/expected"
#fi
#cd "$HOME/src/adbcc"
#cd "$HOME/src/adbcc/adcc-extension/isolation2"
#export ISOLATION2_ROOT="$HOME/src/gpdb$GP_MAJOR/src/test/isolation2"
#make -j"$(nproc)" -C adcc-extension installcheck-isolation2
#make -j"$(nproc)" installcheck
#/home/.local$GP_MAJOR/lib/postgresql/pgxs/src/makefiles/../../src/test/regress/pg_regress --load-extension=plpythonu --load-extension=socket --load-extension=gp_inject_fault cdb_dispatch_replace_ccnt
#/usr/local/lib/postgresql/pgxs/src/makefiles/../../src/test/regress/pg_regress --load-extension=plpythonu --load-extension=socket --load-extension=gp_inject_fault cdb_dispatch_replace_ccnt
#/usr/local/lib/postgresql/pgxs/src/makefiles/../../src/test/regress/pg_regress --load-extension=plpythonu --load-extension=socket --load-extension=gp_inject_fault errors
#/usr/local/lib/postgresql/pgxs/src/makefiles/../../src/test/regress/pg_regress --load-extension=plpythonu --load-extension=gp_inject_fault errors
#"$HOME/src/gpdb$GP_MAJOR/src/test/isolation2/pg_isolation2_regress" --load-extension=plpython3u --load-extension=gp_inject_fault --init-file=./init_file_adcc node_metric
#"$HOME/src/gpdb$GP_MAJOR/src/test/isolation2/pg_isolation2_regress" --load-extension=plpythonu --load-extension=gp_inject_fault --init-file=./init_file_adcc node_metric
#cd "$HOME/src/gpdb$GP_MAJOR/src/test/isolation2"
./pg_isolation2_regress  --init-file="$HOME/src/adbcc/adcc-extension/isolation2/init_file_adcc" --inputdir="$HOME/src/adbcc/adcc-extension/isolation2" --outputdir="$HOME/src/adbcc/adcc-extension/isolation2" --load-extension=gp_inject_fault --load-extension=plpython3u node_metric
#./pg_isolation2_regress  --init-file="$HOME/src/adbcc/adcc-extension/isolation2/init_file_adcc" --inputdir="$HOME/src/adbcc/adcc-extension/isolation2" --outputdir="$HOME/src/adbcc/adcc-extension/isolation2" --load-extension=gp_inject_fault --load-extension=plpython3u spill_snapshot
) 2>&1 | tee "$HOME/adbcc-isolation2.log"
