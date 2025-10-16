#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/arenadata_toolkit.log")

#(
if [[ "$GP_MAJOR" == "7" || "$GP_MAJOR" == "8" ]]; then
    pushd "$HOME/src/arenadata_toolkit"
else
    pushd "$HOME/src/gpdb$GP_MAJOR/gpcontrib/arenadata_toolkit"
fi
make -j$(nproc) clean
make -j$(nproc) install
make -j$(nproc) installcheck
if [[ "$GP_MAJOR" == "7" || "$GP_MAJOR" == "8" ]]; then
    export ISOLATION2_ROOT="$HOME/src/gpdb$GP_MAJOR/src/test/isolation2";
    make -j$(nproc) installcheck-isolation2
fi
#) 2>&1 | tee "$HOME/arenadata_toolkit.log"
popd
