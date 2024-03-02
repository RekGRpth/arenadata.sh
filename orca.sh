#!/bin/sh -eux

(
#export CFLAGS="-O0 -g3"
cd "$HOME/src/gpdb$GP_MAJOR"
ln -fs add_libs/gporca orca_src
cd "$HOME/src/gpdb$GP_MAJOR/add_libs/gporca"
#make -j"$(nproc)" clean
#cmake -D CMAKE_INSTALL_PREFIX="$HOME/.local$GP_MAJOR" .
cmake -D CMAKE_INSTALL_PREFIX="$GPHOME" .
#cmake -D .
make -j"$(nproc)" install
#add_libs/gporca/concourse/build_and_test.py --output_dir=bin_orca --skiptests
) 2>&1 | tee "$HOME/orca.log"
