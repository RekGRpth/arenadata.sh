#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR/gpcontrib/arenadata_toolkit"
make -j$(nproc) clean
make -j$(nproc) install
make -j$(nproc) installcheck
) 2>&1 | tee "$HOME/arenadata_toolkit.log"
