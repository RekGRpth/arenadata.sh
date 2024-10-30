#!/bin/sh -eux

(
createdb contrib_regression || echo $?
cd "$HOME/src/gpdb$GP_MAJOR/src/test/regress"
make -j$(nproc) install
cd "$HOME/src/diskquota/tests/regress"
#cd "$HOME/src/diskquota/tests"
#rm -rf build
#mkdir -p build
#cd build
#make -j"$(nproc)" clean
#cmake .. --target installcheck
#cmake . --target regress
#make -j"$(nproc)" installcheck
#cmake --build . --target regress
#"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --load-extension=gp_inject_fault --init-file=../init_file test_clean_rejectmap_after_drop
#"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --init-file=../init_file test_clean_rejectmap_after_drop_other_extension
#"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --init-file=../init_file test_drop_any_extension
#"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --load-extension=gp_inject_fault --init-file=../init_file config test_create_extension test_recreate test_activetable_limit test_rejectmap_limit test_drop_extension reset_config
#"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --load-extension=gp_inject_fault --init-file=../init_file config test_create_extension test_init_table_size_table test_drop_extension reset_config
"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --load-extension=gp_inject_fault --init-file=../init_file config test_create_extension test_init_table_size_table test_relation_cache test_vacuum test_drop_extension reset_config
#"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --load-extension=gp_inject_fault --init-file=../init_file config test_create_extension test_init_table_size_table reset_config
#"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --load-extension=gp_inject_fault --init-file=../init_file config test_create_extension test_max_monitored_databases test_init_table_size_table test_drop_extension reset_config
#"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --load-extension=gp_inject_fault --init-file=../init_file config test_create_extension test_max_monitored_databases test_init_table_size_table test_drop_extension reset_config
#"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --load-extension=gp_inject_fault --init-file=../init_file config test_create_extension test_init_table_size_table
#"$HOME/src/gpdb$GP_MAJOR/src/test/regress/pg_regress" --init-file=../init_file test_clean_hard_rejectmap_after_drop_other_extension
#gpconfig -c shared_preload_libraries -v diskquota-2.2
#gpstop -afr
) 2>&1 | tee "$HOME/diskquota-regress.log"
