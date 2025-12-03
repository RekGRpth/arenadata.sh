#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/pgbackrest-test.log")

#(
sudo touch /etc/pgbackrest.conf
sudo chown "$USER:$GROUP" /etc/pgbackrest.conf
ln -fs "$HOME/src/pgbackrest" "$HOME/pgbackrest"
#mkdir -p /usr/local/greenplum-db-devel
test -s /usr/local/greenplum-db-devel || ln -fs /usr/local/greengage-db-devel /usr/local/greenplum-db-devel
ln -fs greengage_path.sh /usr/local/greenplum-db-devel/greenplum_path.sh
#pushd "$HOME/src/pgbackrest"
#"$HOME/src/pgbackrest/arenadata/scripts/test_pitr_gpdb.sh"
#"$HOME/src/pgbackrest/arenadata/scripts/test_partial_restore.sh"
"$HOME/src/pgbackrest/arenadata/scripts/test_partial_restore_switch_timeline.sh"
#) 2>&1 | tee "$HOME/pgbackrest-test.log"
#popd
