#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/ecpg.log")

pushd "$HOME/gpdb_src/src/interfaces/ecpg"
ln -fs ../../../test/regress/gpdiff.pl test/gpdiff.pl
ln -fs ../../../test/regress/atmsort.pm test/atmsort.pm
ln -fs ../../../test/regress/explain.pm test/explain.pm
ln -fs ../../../test/regress/GPTest.pm test/GPTest.pm
ln -fs ../../../test/regress/gpstringsubs.pl test/gpstringsubs.pl
make -j$(nproc) installcheck -i
popd
