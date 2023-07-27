#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR/gpMgmt"
make -j$(nproc) install
make -j$(nproc) behave tags=gpexpand
) 2>&1 | tee "$HOME/behave.log"
