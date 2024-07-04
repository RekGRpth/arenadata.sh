#!/bin/sh -eux

(
#test -f "$HOME/data$GP_MAJOR/qddir/demoDataDir-1/postmaster.pid" && test -f "/tmp/.s.PGSQL.${GP_MAJOR}432" &&  
gpstop -af || echo $?
rm -rf /tmp/.s.PGSQL.* "$HOME/.ssh/known_hosts"
rm -rf "$HOME/data$GP_MAJOR/*"
#rm -rf "$HOME/data$GP_MAJOR"
#ln -fs "/tmpfs/data$GP_MAJOR" "$HOME/data$GP_MAJOR"
#mkdir -p "$HOME/data$GP_MAJOR"
#sudo mount -o bind "/tmpfs/data$GP_MAJOR" "$HOME/data$GP_MAJOR"
killall -9 psql || echo $?
killall -9 postgres || echo $?
BLDWRAP_POSTGRES_CONF_ADDONS=
if [ "$GP_MAJOR" -eq "6" ]; then
    make -C "$HOME/src/gpdb$GP_MAJOR/contrib/dummy_seclabel" -j"$(nproc)" install
#    cd "$HOME/src/gpdb$GP_MAJOR/contrib/dummy_seclabel"
#    make -j"$(nproc)" install
#    gpconfig -c client_connection_check_interval -v 2min
#    gpconfig -c shared_preload_libraries -v dummy_seclabel
#    gpstop -afr
    BLDWRAP_POSTGRES_CONF_ADDONS="shared_preload_libraries=dummy_seclabel"
elif [ "$GP_MAJOR" -eq "7" ]; then
    make -C "$HOME/src/gpdb$GP_MAJOR/src/test/modules/dummy_seclabel" -j"$(nproc)" install
#    cd "$HOME/src/gpdb$GP_MAJOR/contrib/dummy_seclabel"
#    make -j"$(nproc)" install
#    gpconfig -c client_connection_check_interval -v 2min
#    gpconfig -c shared_preload_libraries -v dummy_seclabel
#    gpstop -afr
    BLDWRAP_POSTGRES_CONF_ADDONS="shared_preload_libraries='dummy_seclabel'"
fi
cd "$HOME/src/gpdb$GP_MAJOR"
export BLDWRAP_POSTGRES_CONF_ADDONS="$BLDWRAP_POSTGRES_CONF_ADDONS"
#export BLDWRAP_POSTGRES_CONF_ADDONS="gp_keep_all_xlog=true"
#export BLDWRAP_POSTGRES_CONF_ADDONS="wal_recycle=off"
#export BLDWRAP_POSTGRES_CONF_ADDONS="wal_debug=on"
make create-demo-cluster
createdb --owner="$USER" "$USER"
) 2>&1 | tee "$HOME/demo.log"
#source $HOME/src/gpdb$GP_MAJOR/gpAux/gpdemo/gpdemo-env.sh
