#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR/gpAux/gpperfmon"
#mkdir build
#cd build
#cmake ..
make -j$(nproc) install
cd "$HOME/src/gpdb$GP_MAJOR/gpMgmt"
make -j$(nproc) install
#source $HOME/qa.sh
#make -f Makefile.behave behave "$*" TAR=tar 2>&1
#make -j$(nproc) behave tags=gpexpand
#make -j$(nproc) behave tags=gplogfilter
make -j$(nproc) behave tags=gpperfmon
#make -j$(nproc) -f Makefile.behave behave tags=gplogfilter
) 2>&1 | tee "$HOME/behave.log"
