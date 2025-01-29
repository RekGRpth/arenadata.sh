#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR/gpMgmt/bin"
#make -j"$(nproc)" unitdevel
python3 -m unittest discover --verbose -s gppylib -p "test_unit_gprebalance.py"
) 2>&1 | tee "$HOME/unitdevel.log"
