#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/deb.log")

sudo apt install -y build-essential devscripts debhelper dh-python ccache ninja-build python-pip
pushd "$HOME/src/gpdb$GP_MAJOR"
make -C gpAux pkg-deb
popd
