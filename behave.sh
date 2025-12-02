#!/bin/bash -ex

exec 2>&1 &> >(tee "$HOME/behave.log")

#if [ "$(hostname)" != "cdw" ]; then
#    sudo bash -c 'echo "$(hostname -i) cdw" >>/etc/hosts'
#    sudo bash -c 'echo "$(hostname -i) sdw1" >>/etc/hosts'
#    sudo bash -c 'echo "$(hostname -i) sdw2" >>/etc/hosts'
#    sudo bash -c 'echo "$(hostname -i) sdw3" >>/etc/hosts'
#    sudo hostname cdw
#fi
#unset PGPORT
#unset PORT_BASE
#unset MASTER_DATA_DIRECTORY
#unset COORDINATOR_DATA_DIRECTORY

pushd "$HOME/gpdb_src/gpMgmt"
#behave test/behave/mgmt_utils --tags=gpstart -n 'gpstart succeeds when cluster shut down during segment promotion'
#behave test/behave/mgmt_utils --tags=gpcheckcat
behave test/behave/mgmt_utils --tags=gpperfmon
#behave test/behave/mgmt_utils --tags=gpactivatestandby -n 'gpactivatestandby -f forces standby coordinator to start'
#behave test/behave/mgmt_utils --tags=gpinitstandby -n 'gpinitstandby should create pg_hba entry to segment primary'
#make -j$(nproc) behave tags=gpperfmon
popd
exit

#(
if [ ! -f /home/gpadmin/sqldump/dump.sql ]; then
    mkdir -p /home/gpadmin/sqldump
    wget -nv https://rt.adsw.io/artifactory/common/dump.sql.xz -O /home/gpadmin/sqldump/dump.sql.xz
    xz -d /home/gpadmin/sqldump/dump.sql.xz
fi
#pushd "$HOME/gpdb_src/gpMgmt"
#make -j$(nproc) install
#gpstop -a || echo $?
#sudo rm -rf /data/gpdata
sudo mkdir -p /data/gpdata
sudo chown -R $USER:$GROUP /data/gpdata
#sudo bash -c 'echo "cdw" >/etc/hostname'
if [ "$(hostname)" != "cdw" ]; then
    sudo bash -c 'echo "$(hostname -i) cdw" >>/etc/hosts'
    sudo bash -c 'echo "$(hostname -i) sdw1" >>/etc/hosts'
    sudo bash -c 'echo "$(hostname -i) sdw2" >>/etc/hosts'
    sudo bash -c 'echo "$(hostname -i) sdw3" >>/etc/hosts'
    sudo hostname cdw
fi
rm "$HOME/gpAdminLogs/"* || echo $?
#cd /data/gpdata
#cd "$HOME"
#ln -fs "$HOME/gpdb_src/gpMgmt/test" .
#gpstop -afr
dropdb gptest || echo $?
createdb --owner="$USER" gptest || echo $?
gpstop -a || echo $?
export PGPORT=15432
export PORT_BASE=$PGPORT
#export MASTER_DATA_DIRECTORY=/data/gpdata/coordinator/gpseg-1
#/home/gpadmin/src/gpdb6u/gpAux/gpdemo/datadirs/qddir/demoDataDir-1
#export DATADIRS=$HOME/gpdb_src/gpAux/gpdemo/datadirs
#export MASTER_DATA_DIRECTORY=$DATADIRS/qddir/demoDataDir-1
#export MASTER_DATA_DIRECTORY=/data/gpdata/gpexpand/data/master/gpseg-1
export DATADIRS=/data/gpdata/gpexpand/data
export MASTER_DATA_DIRECTORY="$DATADIRS/master/gpseg-1"
#cd "$HOME/gpdb_src"
#sudo groupadd --system docker
#sudo groupmems -a $USER -g docker
#export IMAGE=behave
#docker build -t $IMAGE -f arenadata/Dockerfile .
#source $HOME/qa.sh
#make -f Makefile.behave behave "$*" TAR=tar 2>&1
#make -j$(nproc) behave tags=gpexpand
#make -j$(nproc) behave tags=gplogfilter
#make -j$(nproc) behave tags=gpperfmon
#make -j$(nproc) behave -n "gpperfmon does not lose the query text if its text differs from the text in pg_stat_activity"
#make -j$(nproc) -f Makefile.behave behave tags=gplogfilter
#make -j$(nproc) -f Makefile.behave behave tags=gpexpand
#behave test/behave/mgmt_utils --tags=gpperfmon -n "install gpperfmon" -n "run gpperfmon" -n "get info about current queries"
#behave test/behave/mgmt_utils --tags=gpperfmon -n "install gpperfmon" -n "run gpperfmon" -n "gpperfmon does not log PL/pgSQL statements with log_min_messages < debug4"
#behave test/behave/mgmt_utils --tags=gpperfmon -n "install gpperfmon" -n "run gpperfmon" -n "gpperfmon only logs nested statements if log_min_messages is set to debug4 or debug5"
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
#behave test/behave/mgmt_utils --tags=gprecoverseg -n "gprecoverseg should not give warning if pg_basebackup is running for the up segments"
#behave test/behave/mgmt_utils --tags=gpexpand -n "expand the cluster by adding more segments"
#behave test/behave/mgmt_utils --tags=gpexpand --name="Avoid overwriting the tar file on coordinator"
#behave test/behave/mgmt_utils --tags=gpexpand -n "after resuming a duration interrupted redistribution, tables are restored" -n "after a duration interrupted redistribution, state file on standby matches coordinator" -n "after resuming an end time interrupted redistribution, tables are restored"
#behave test/behave/mgmt_utils --tags=gpstop -n 'gpstop gpstop should not print "Failed to kill processes for segment" when locale is different from English'
#behave test/behave/mgmt_utils --tags=gpexpand -n 'gpexpand should skip already expanded/broken tables when redistributing'
#behave test/behave/mgmt_utils --tags=gpexpand --name='gpexpand should skip already expanded/broken tables when redistributing' --verbose
#behave test/behave/mgmt_utils --tags=gpexpand --name='after resuming a duration interrupted redistribution, tables are restored' --verbose
#behave test/behave/mgmt_utils --tags=gpperfmon -n "install gpperfmon" -n "run gpperfmon" -n "gpperfmon ignore ALTER TABLE SET DISTRIBUTED BY" -n "gpperfmon does not lose the query text if its text differs from the text in pg_stat_activity"
#behave test/behave/mgmt_utils --tags=gpperfmon -n "install gpperfmon" -n "run gpperfmon" -n "gpperfmon adds to diskspace_history table"
#behave test/behave/mgmt_utils --tags=gpperfmon -n "gpperfmon adds to diskspace_history table"
#behave test/behave/mgmt_utils --tags=gpperfmon -k -n "gpperfmon adds to diskspace_history table"
#behave test/behave/mgmt_utils --tags=gplogfilter -k -n "invalid begin and end arguments"
behave test/behave/mgmt_utils --tags=gplogfilter -k
#arenadata/scripts/run_behave_tests.bash "gpexpand should skip already expanded/broken tables when redistributing"
#cd "$HOME/gpdb_src"
#arenadata/scripts/run_behave_tests.bash "gpexpand Avoid overwriting the tar file on coordinator"
#export PEXPECT_LIB="$GPHOME/bin/lib"
#export TEST_DIR="$HOME/gpdb_src/gpMgmt"
#export PYTHONPATH="$PYTHONPATH":"$PEXPECT_LIB":"$TEST_DIR"
#PYTHONPATH="$PYTHONPATH":"$GPHOME/bin/lib":"$HOME/gpdb_src/gpMgmt" 
#behave "$HOME/gpdb_src/gpMgmt/test/behave/"* --tags=gpexpand --name='gpexpand should skip already expanded/broken tables when redistributing' --verbose
#behave test/behave/mgmt_utils --tags=gpexpand --name='gpexpand should skip already expanded/broken tables when redistributing' --verbose
#behave test/behave/mgmt_utils --tags=gpactivatestandby --name='gprecoverseg recoveries failed segment when standby works instead of coordinator' --verbose
#behave test/behave/mgmt_utils --tags=gpinitstandby --name='gpinitstandby should create pg_hba entry to segment primary' --verbose
#behave test/behave/mgmt_utils --tags=gpinitstandby --name='gpinitstandby should create pg_hba standby entry to segment primary and mirror' --verbose
#behave test/behave/mgmt_utils --tags=gpactivatestandby --name='gpstate after running gpactivatestandby works' --verbose
#) 2>&1 | tee "$HOME/behave.log"
