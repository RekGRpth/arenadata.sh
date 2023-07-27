#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR/src/test/regress"
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file appendonly
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file create_function_1 create_type create_table int8 int4 copy with
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file uaocs_compaction/outdatedindex
#./pg_regress --load-extension=gp_inject_fault --init-file=init_file sirv_functions appendonly alter_distpol_dropped vacuum_gp sreh
./pg_regress --load-extension=gp_inject_fault --init-file=init_file appendonly
#make -j$(nproc) installcheck -i
) 2>&1 | tee "$HOME/regress.log"
