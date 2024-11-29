#!/bin/sh -eux

(
#export PGOPTIONS="-c optimizer=on -c optimizer_enable_table_alias=off"
#export PGOPTIONS="-c optimizer=off"
cd "$HOME/src/gpdb$GP_MAJOR/src/test/regress"
make -j$(nproc) clean
make -j$(nproc) install
cd "$HOME/src/gpdb$GP_MAJOR/src/bin/gpfdist/regress"
make -j$(nproc) clean
make -j$(nproc) install
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file alter_table_ao alter_table_aocs
#../../../src/test/regress/pg_regress --dbname=gpfdist_regression exttab1 custom_format gpfdist2 gpfdist_path gpfdist_ssl gpfdists_multiCA gpfdist2_compress --init-file=init_file
#../../../../src/test/regress/pg_regress --dbname=gpfdist_regression --init-file=init_file exttab1 gpfdist2
make -j$(nproc) installcheck -i
) 2>&1 | tee "$HOME/gpfdist.log"
