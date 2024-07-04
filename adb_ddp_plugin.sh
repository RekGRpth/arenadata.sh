#!/bin/sh -eux

(
cd "$HOME/src/adb_ddp_plugin/zlog"
make -j"$(nproc)"
make -j"$(nproc)" install
cd "$HOME/src/adb_ddp_plugin"
export DD_BOOST_INC_DIR="$HOME/src/adb_ddp_plugin/opt/ddp/ddp_include"
export DD_BOOST_LIB_DIR="$HOME/src/adb_ddp_plugin/opt/lib/release/linux/64"
#export DDBOOST_PLUGIN=gpbackup_ddboost_plugin
export LIBCESTER_INC_DIR="$HOME/src/libcester/include"
#export ZLOG_LIB_DIR="$HOME/.local$GP_MAJOR/lib"
killall adb_ddp_plugin || echo $?
export CFLAGS="-O0 -ggdb -g3 -fno-omit-frame-pointer"
export CXXFLAGS="-DGPOS_DEBUG -O0 -ggdb -g3 -fno-omit-frame-pointer"
make -j"$(nproc)" clean
make -j"$(nproc)" install
#make test
make run_unit_tests
#make run_integration_tests
#plugins/plugin_test.sh plugin_path plugin_config_path
) 2>&1 | tee "$HOME/adb_ddp_plugin.log"
