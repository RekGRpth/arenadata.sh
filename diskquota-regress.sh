#!/bin/sh -eux

(
cd "$HOME/src/diskquota/tests/regress"
#rm -rf build
#mkdir -p build
#cd build
#make -j"$(nproc)" clean
#cmake .. --target installcheck
#cmake ..
#make -j"$(nproc)" install
#"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --load-extension=gp_inject_fault --init-file=../init_file test_clean_rejectmap_after_drop
"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --init-file=../init_file test_clean_rejectmap_after_drop_other_extension
#gpconfig -c shared_preload_libraries -v diskquota-2.2
#gpstop -afr
) 2>&1 | tee "$HOME/diskquota-regress.log"
