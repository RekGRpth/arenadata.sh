#!/bin/bash -ex

exec 2>&1 &> >(tee "$HOME/behave.log")

rm -rf "$HOME/gpAdminLogs/"*.log "$HOME/gpAdminLogs/"*.out /tmp/allure-results
sudo chmod u+s "$(which ping)"

#if [ "$(hostname)" != "cdw" ]; then
#    sudo bash -c 'echo "$(hostname -i) cdw" >>/etc/hosts'
#    sudo bash -c 'echo "$(hostname -i) sdw1" >>/etc/hosts'
#    sudo bash -c 'echo "$(hostname -i) sdw2" >>/etc/hosts'
#    sudo bash -c 'echo "$(hostname -i) sdw3" >>/etc/hosts'
#    sudo hostname cdw
#fi
if [[ "$GP_MAJOR" == "6" ]]; then
unset COORDINATOR_DATA_DIRECTORY
unset DATADIRS
unset MASTER_DATA_DIRECTORY
unset PGPORT
unset PORT_BASE
unset PGDATA
unset SEGMENT_0_DATA_DIRECTORY
unset SEGMENT_1_DATA_DIRECTORY
unset SEGMENT_2_DATA_DIRECTORY
unset STANDBY_DATA_DIRECTORY
unset MIRROR_0_DATA_DIRECTORY
unset MIRROR_1_DATA_DIRECTORY
unset MIRROR_2_DATA_DIRECTORY
fi

export LANG=en_US.UTF-8

if [[ "$GP_MAJOR" == "6" ]]; then
for HOST in cdw sdw1 sdw2 sdw3 sdw4 sdw5 sdw6; do
    echo $HOST
    IP="$(host "$HOST" | grep 'has address' | head -n 1 | cut -d ' ' -f 4)"
    gpssh -e -h cdw -h sdw1 -h sdw2 -h sdw3 -h sdw4 -h sdw5 -h sdw6 <<EOF
        cat /etc/hosts | sed "/$IP $HOST/d" | sudo bash -c "cat >/etc/hosts"
        grep -q "$IP $HOST" /etc/hosts || sudo bash -c "echo '$IP $HOST' >>/etc/hosts"
EOF
done
fi

#exit

if [[ "$GP_MAJOR" == "6" ]]; then
gpssh -v -e -h cdw -h sdw1 -h sdw2 -h sdw3 -h sdw4 -h sdw5 -h sdw6 <<EOF
sudo mkdir -p /data
sudo chown -R "$USER":"$GROUP" /data
killall -9 psql
killall -9 sleep
killall -9 postgres
killall -9 gpmmon
killall -9 gpsmon
rm -rf /tmp/.s.PGSQL.* /data/gpdata /tmp/gpexpand_behave
EOF
fi
mkdir -p /data/gpdata/gpexpand
rm -rf "$HOME/.ssh/known_hosts"
pushd "$HOME/gpdb_src/gpMgmt"
#behave test/behave/mgmt_utils --tags=gpstart -n 'gpstart succeeds when cluster shut down during segment promotion'
#behave test/behave/mgmt_utils --tags=gpcheckcat
#behave test/behave/mgmt_utils --tags=@gpperfmon
#make -f Makefile.behave behave tags=@gpperfmon --tags ~@gpperfmon_queries_history_metrics --verbose
#behave test/behave/mgmt_utils --tags=@gpperfmon --tags ~@gpperfmon_queries_history_metrics --verbose
#behave test/behave/mgmt_utils/gpperfmon.feature --tags @gpperfmon --tags ~@gpperfmon_diskspace_history --verbose
#behave test/behave/mgmt_utils/gpperfmon.feature --tags @gpperfmon_diskspace_history --verbose
#behave test/behave/mgmt_utils/gpmovemirrors.feature --tags ~concourse_cluster,demo_cluster -n 'gpmovemirrors can move mirrors even if start fails for some mirrors' --verbose --no-skipped
#behave test/behave/mgmt_utils/gpaddmirrors.feature -n 'gprecoverseg works correctly on a newly added mirror with HBA_HOSTNAMES=0' --verbose --no-skipped
#behave test/behave/mgmt_utils/gpcheckcat.feature -n 'gpcheckcat should drop leaked schemas' --verbose --no-skipped
#behave test/behave/mgmt_utils/gpaddmirrors.feature --tags concourse_cluster -n 'gprecoverseg works correctly on a newly added mirror with HBA_HOSTNAMES=1' --verbose --no-skipped
#behave test/behave/mgmt_utils/gpaddmirrors.feature --tags concourse_cluster -n 'gprecoverseg works correctly on a newly added mirror with HBA_HOSTNAMES=1' --verbose --no-skipped
#export LANG=en_US.UTF-8
#behave test/behave/mgmt_utils/gpinitsystem.feature --tags ~concourse_cluster,demo_cluster -n 'gpinitsystem creates a cluster with data_checksums on' --verbose --no-skipped
#behave test/behave/mgmt_utils/gpinitsystem.feature --tags ~concourse_cluster,demo_cluster -n 'gpinitsystem creates a cluster with data_checksums off' --verbose --no-skipped
#behave test/behave/mgmt_utils/gpinitsystem.feature --tags ~concourse_cluster,demo_cluster -n 'gpinitsystem creates a cluster with data_checksums on' --verbose --no-skipped
#behave test/behave/mgmt_utils/gpinitsystem.feature --tags ~concourse_cluster,demo_cluster -n 'gpinitsystem creates a cluster with data_checksums' --verbose --no-skipped
#behave test/behave/mgmt_utils/gpconfig.feature --tags ~concourse_cluster,demo_cluster -n 'running gpconfig test case: utf-8 works, for guc type: string' --verbose --no-skipped
#behave test/behave/mgmt_utils/gpconfig.feature --tags ~concourse_cluster,demo_cluster -n 'gpconfig checks liveness of correct number of hosts' --verbose --no-skipped
#behave test/behave/mgmt_utils/gpstop.feature --tags ~concourse_cluster,demo_cluster -n 'gpstop runs with given master data directory option' --verbose --no-skipped
#behave test/behave/mgmt_utils/gplogfilter.feature --tags ~concourse_cluster,demo_cluster -n 'time range covers all files' --verbose --no-skipped
#behave test/behave/mgmt_utils/gpconfig.feature --tags concourse_cluster -n 'running gpconfig test case: utf-8 works, for guc type: string' --verbose --no-skipped
#behave test/behave/mgmt_utils/gpinitsystem.feature --tags concourse_cluster --verbose --no-skipped
#flags="--tags gprecoverseg_newhost --tags=concourse_cluster --name 'failed host is not in reach gprecoverseg recovery works well with all instances recovered'" make -f Makefile.behave behave
#flags="--tags=concourse_cluster --tags gprecoverseg_newhost --name 'failed host is not in reach gprecoverseg recovery works well with all instances recovered'" make -f Makefile.behave behave
#flags="--tags gpexpand --tags=~concourse_cluster -f behave_utils.ci.formatter:CustomFormatter -o non-existed-output -f allure_behave.formatter:AllureFormatter -o /tmp/allure-results -f pretty -o /dev/stdout --name 'on expand check if one or more cluster is down'" make -f Makefile.behave behave
#flags="--tags gpexpand --tags=~concourse_cluster -f behave_utils.ci.formatter:CustomFormatter -o non-existed-output -f allure_behave.formatter:AllureFormatter -o /tmp/allure-results -f pretty --name 'on expand check if one or more cluster is down'" make -f Makefile.behave behave
#flags="--tags gpexpand --tags=~concourse_cluster -f pretty -o /dev/stdout --show-source --verbose --name 'on expand check if one or more cluster is down'" make -f Makefile.behave behave
#behave test/behave/mgmt_utils/gprecoverseg_newhost.feature --tags concourse_cluster -n '"gprecoverseg -p newhosts" successfully recovers for one_host_down' --verbose --no-skipped
#behave test/behave/mgmt_utils/gpexpand.feature --tags ~concourse_cluster -n 'on expand check if one or more cluster is down' --verbose --no-skipped
#behave test/behave/mgmt_utils/gpexpand.feature --tags ~concourse_cluster -n 'Verify should succeed when expand partition table placed in different schemas' -n 'on expand check if one or more cluster is down' --verbose --no-skipped
#behave test/behave/mgmt_utils/gpexpand.feature --tags ~concourse_cluster -n 'inject a fail and test if retry is ok' -n 'on expand check if one or more cluster is down' --verbose --no-skipped
#behave test/behave/mgmt_utils/gpexpand.feature --tags ~concourse_cluster -n 'on expand check if one or more cluster is not in their preferred role' --verbose --no-skipped
#behave test/behave/mgmt_utils/gpexpand.feature --tags ~concourse_cluster -n 'expand a cluster that has mirrors and check that gpexpand does not copy extra data directories from master' --verbose --no-skipped
#behave test/behave/mgmt_utils/gprecoverseg.feature --tags ~concourse_cluster,demo_cluster -n 'gprecoverseg mixed recovery displays pg_basebackup and rewind progress to the user' --verbose --no-skipped
#behave test/behave/mgmt_utils/gpstart.feature --tags ~concourse_cluster,demo_cluster -n 'gpstart runs with given master data directory option' --verbose --no-skipped
#behave test/behave/mgmt_utils/gpstate.feature --tags ~concourse_cluster,demo_cluster -n 'gpstate -b logs cluster for a cluster where the mirrors failed over to primary' --verbose --no-skipped
#behave test/behave/mgmt_utils/gprecoverseg.feature --tags ~concourse_cluster,demo_cluster -n 'gprecoverseg recovery with a recovery configuration file and differential flag' --verbose --no-skipped
#behave test/behave/mgmt_utils/gprecoverseg.feature --tags ~concourse_cluster,demo_cluster -n 'gprecoverseg recovers segment when config file contains hostname on demo cluster' --verbose --no-skipped
#behave test/behave/mgmt_utils/gprecoverseg.feature --tags ~concourse_cluster,demo_cluster -n 'gprecoverseg skips recovery when config file contains invalid hostname on demo cluster' --verbose --no-skipped
#behave test/behave/mgmt_utils/gprecoverseg.feature --tags ~concourse_cluster,demo_cluster -n 'gprecoverseg rebalance aborts and throws exception if replay lag on mirror is more than or equal to the allowed limit' --verbose --no-skipped
#behave test/behave/mgmt_utils/gprecoverseg.feature --tags ~concourse_cluster,demo_cluster -n 'None of the accumulated wal (after running pg_start_backup and before copying the pg_control file) is lost during differential' --verbose --no-skipped
#behave test/behave/mgmt_utils/gprecoverseg.feature --tags ~concourse_cluster,demo_cluster -n 'Cleanup orphaned directory of dropped database after differential recovery' --verbose --no-skipped
#behave test/behave/mgmt_utils/gprecoverseg.feature --tags concourse_cluster -n 'gprecoverseg recovery with a recovery configuration file and differential flag' --verbose --no-skipped
#behave test/behave/mgmt_utils/gprecoverseg.feature --tags concourse_cluster -n 'Propagating env var' -n 'gprecoverseg gives warning if pg_rewind already running for one failed segments' --verbose --no-skipped
#behave test/behave/mgmt_utils/gprecoverseg.feature --tags concourse_cluster -n 'gprecoverseg gives warning if pg_rewind already running for one failed segments' --verbose --no-skipped
#behave test/behave/mgmt_utils/gprecoverseg.feature --tags concourse_cluster -n 'None of the accumulated wal (after running pg_start_backup and before copying the pg_control file) is lost during differential' --verbose --no-skipped
#behave test/behave/mgmt_utils/gprecoverseg.feature --tags concourse_cluster -n 'None of the accumulated wal ' --verbose --no-skipped
#behave test/behave/mgmt_utils/gprecoverseg.feature --tags concourse_cluster -n 'gpstate track of differential recovery for single host' --verbose --no-skipped
#behave test/behave/mgmt_utils/gpssh.feature --tags ~concourse_cluster,demo_cluster --verbose --no-skipped
#behave test/behave/mgmt_utils/gpexpand.feature --tags ~concourse_cluster,demo_cluster -n "after resuming a duration interrupted redistribution, tables are restored" --verbose --no-skipped
#behave test/behave/mgmt_utils/gpexpand.feature --tags ~concourse_cluster,demo_cluster -n "after resuming an end time interrupted redistribution, tables are restored" --verbose --no-skipped
#behave test/behave/mgmt_utils/gpexpand.feature --tags ~concourse_cluster,demo_cluster -n "expand a cluster without restarting db and catalog has been copied" --verbose --no-skipped
#behave test/behave/mgmt_utils/gpexpand.feature --tags ~concourse_cluster,demo_cluster -n "on expand check if one or more cluster is down" --verbose --no-skipped
#behave test/behave/mgmt_utils/gpexpand.feature --tags ~concourse_cluster,demo_cluster -n "on expand check if one or more cluster is not in their preferred role" --verbose --no-skipped
#behave test/behave/mgmt_utils/gpexpand.feature --tags ~concourse_cluster,demo_cluster -n "expand a cluster that has mirrors and check that gpexpand does not copy extra data directories from master" --verbose --no-skipped
#behave test/behave/mgmt_utils/gppkg.feature --tags ~demo_cluster,concourse_cluster -n "gppkg --install should report success because the package is not yet installed" --verbose --no-skipped
#behave test/behave/mgmt_utils/gppkg.feature --tags ~concourse_cluster -n "gppkg --install should report success because the package is not yet installed" --verbose --no-skipped
#behave test/behave/mgmt_utils/gppkg.feature --tags ~demo_cluster --tags concourse_cluster -n "gppkg --install should report success because the package is not yet installed" --verbose --no-skipped
#behave test/behave/mgmt_utils/gpssh.feature --tags ~concourse_cluster,demo_cluster -n 'gpssh exceptions' --verbose --no-skipped
#behave test/behave/mgmt_utils/gpssh.feature --tags ~concourse_cluster,demo_cluster -n 'gpssh succeeds when network has latency' --verbose --no-skipped
#behave test/behave/mgmt_utils/ggssh_exkeys.feature --tags concourse_cluster -n 'N-to-N exchange works' --verbose --no-skipped
#behave test/behave/mgmt_utils/ggssh_exkeys.feature --tags concourse_cluster -n 'IPv6 addresses are accepted' --verbose --no-skipped
#behave test/behave/mgmt_utils/ggssh_exkeys.feature --tags concourse_cluster -n 'IPv6 addresses are accepted' --verbose
#behave test/behave/mgmt_utils/gprecoverseg.feature --tags concourse_cluster -n 'gprecoverseg recovery with a recovery configuration file and differential flag' -n 'gprecoverseg" with a recovery configuration file specifying the recovery type' -n 'differential recovery runs successfully' -n 'Differential recovery succeeds if previous incremental recovery failed' -n 'Differential recovery succeeds if previous full recovery failed' -n 'gpstate track of differential recovery for single host' --verbose --no-skipped
#behave test/behave/mgmt_utils/gpstate.feature --tags concourse_cluster -n 'gpstate -e -v logs no errors when the user unsets PGDATABASE' --verbose --no-skipped
#behave test/behave/mgmt_utils/gpstate.feature --tags ~demo_cluster --tags concourse_cluster -n 'gpstate -e -v logs no errors when the user unsets PGDATABASE' --verbose --no-skipped
#behave test/behave/mgmt_utils/gpstate.feature --tags concourse_cluster -n 'gpstate -e -v logs no errors when the user unsets PGDATABASE' --verbose
#behave test/behave/mgmt_utils/gprecoverseg.feature --verbose
#behave test/behave/mgmt_utils/gprecoverseg.feature -n 'Differential recovery succeeds if previous full recovery failed' --verbose
#behave test/behave/mgmt_utils/gprecoverseg.feature -n 'incremental recovery skips unreachable segments' --verbose --no-skipped
#behave test/behave/mgmt_utils --tags=gpactivatestandby -n 'gpactivatestandby -f forces standby coordinator to start'
#behave test/behave/mgmt_utils --tags=gpinitstandby -n 'gpinitstandby should create pg_hba entry to segment primary'
#make -j$(nproc) behave tags=gpperfmon
#export flags="--verbose --tags gprecoverseg_newhost --name '\"gprecoverseg -p newhosts\" successfully recovers for one_host_down'"
#make -f Makefile.behave behave tags=gprecoverseg_newhost flags="--name 'successfully recovers for one_host_down' --verbose"
#make -f Makefile.behave behave tags=gpconfig flags="--tags ~concourse_cluster,demo_cluster --verbose --no-skipped"
#flags="--tags gpconfig --verbose --tags=~concourse_cluster,demo_cluster --no-skipped --name 'running gpconfig test case: utf-8 works, for guc type: string'" make -f Makefile.behave behave
#flags="--tags gpconfig --verbose --tags=~concourse_cluster,demo_cluster" make -f Makefile.behave behave
#flags="--tags ggssh_exkeys --verbose --tags=concourse_cluster --name 'IPv6 addresses are accepted'" make -f Makefile.behave behave
#behave test/behave/mgmt_utils/gpstate.feature --tags gpstate --tags=concourse_cluster -n 'gpstate -e -v logs no errors when the user unsets PGDATABASE' --verbose
behave test/behave/mgmt_utils/gpstate.feature --tags=concourse_cluster -n 'gpstate -e -v logs no errors when the user unsets PGDATABASE' --verbose
#behave test/behave/mgmt_utils/gprecoverseg_newhost.feature --tags=concourse_cluster -n 'gpstate -e -v logs no errors when the user unsets PGDATABASE' --verbose
#flags="--tags gpstate --tags=concourse_cluster --name 'gpstate -e -v logs no errors when the user unsets PGDATABASE'" make -f Makefile.behave behave
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
behave test/behave/mgmt_utils --tags=gpexpand -n "expand the cluster by adding more segments"
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
