#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR/gpMgmt"
make -j$(nproc) install
#source $HOME/qa.sh
#make -f Makefile.behave behave "$*" TAR=tar 2>&1
#make -j$(nproc) behave tags=gpexpand
#make -j$(nproc) behave tags=gplogfilter
#make -j$(nproc) behave tags=gpperfmon
#make -j$(nproc) behave -n "gpperfmon does not lose the query text if its text differs from the text in pg_stat_activity"
#make -j$(nproc) -f Makefile.behave behave tags=gplogfilter
behave test/behave/mgmt_utils --tags=gpperfmon -n "gpperfmon does not lose the query text if its text differs from the text in pg_stat_activity"
) 2>&1 | tee "$HOME/behave.log"
