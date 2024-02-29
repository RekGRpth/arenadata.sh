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
#behave test/behave/mgmt_utils --tags=gpperfmon -n "install gpperfmon" -n "run gpperfmon" -n "get info about current queries"
#behave test/behave/mgmt_utils --tags=gpperfmon -n "install gpperfmon" -n "run gpperfmon" -n "get info about current queries"
#behave test/behave/mgmt_utils --tags=gpperfmon -n "install gpperfmon" -n "run gpperfmon"
#behave test/behave/mgmt_utils --tags=gpperfmon -n "run gpperfmon" -n "get info about current queries"
#behave test/behave/mgmt_utils --tags=gpperfmon -n "get info about current queries"
#behave test/behave/mgmt_utils --tags=gpperfmon -n "install gpperfmon" -n "run gpperfmon" -n "get info about current queries" -n "gpperfmon adds to database_history table"
#behave test/behave/mgmt_utils --tags=gpperfmon -n "run gpperfmon" -n "get info about current queries" -n "gpperfmon adds to database_history table"
#behave test/behave/mgmt_utils --tags=gpperfmon -n "get info about current queries" -n "gpperfmon adds to database_history table"
#behave test/behave/mgmt_utils --tags=gpperfmon -n "install gpperfmon" -n "run gpperfmon" -n "gpperfmon does not lose the query text if its text differs from the text in pg_stat_activity"
#behave test/behave/mgmt_utils --tags=gpperfmon -n "install gpperfmon" -n "run gpperfmon" -n "gpperfmon ignore ALTER TABLE SET DISTRIBUTED BY"
#behave test/behave/mgmt_utils --tags=gpperfmon -n "gpperfmon ignore ALTER TABLE SET DISTRIBUTED BY"
#behave test/behave/mgmt_utils --tags=gpperfmon -n "gpperfmon ignore ALTER TABLE SET DISTRIBUTED BY" -n "gpperfmon does not lose the query text if its text differs from the text in pg_stat_activity"
behave test/behave/mgmt_utils --tags=gprecoverseg -n "gprecoverseg should not give warning if pg_basebackup is running for the up segments"
#behave test/behave/mgmt_utils --tags=gpperfmon -n "install gpperfmon" -n "run gpperfmon" -n "gpperfmon ignore ALTER TABLE SET DISTRIBUTED BY" -n "gpperfmon does not lose the query text if its text differs from the text in pg_stat_activity"
) 2>&1 | tee "$HOME/behave.log"
