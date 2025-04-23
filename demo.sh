#!/bin/bash -eux

(
#test -f "$HOME/data$GP_MAJOR/qddir/demoDataDir-1/postmaster.pid" && test -f "/tmp/.s.PGSQL.${GP_MAJOR}432" &&  
gpstop -af || echo $?
rm -rf /tmp/.s.PGSQL.* "$HOME/.ssh/known_hosts"
#rm -rf "$HOME/data/*"
#rm -rf "$HOME/data$GP_MAJOR/*"
#rm -rf "$HOME/data$GP_MAJOR"
#ln -fs "/tmpfs/data$GP_MAJOR" "$HOME/data$GP_MAJOR"
#mkdir -p "$HOME/data$GP_MAJOR"
#sudo mount -o bind "/tmpfs/data$GP_MAJOR" "$HOME/data$GP_MAJOR"
killall -9 psql || echo $?
killall -9 postgres || echo $?
BLDWRAP_POSTGRES_CONF_ADDONS=
if [[ "$GP_MAJOR" == "6c" || "$GP_MAJOR" == "6u" ]]; then
    if make -C "$HOME/src/gpdb$GP_MAJOR/contrib/dummy_seclabel" -j"$(nproc)" install; then
        BLDWRAP_POSTGRES_CONF_ADDONS="shared_preload_libraries=dummy_seclabel"
    fi
elif [[ "$GP_MAJOR" == "7c" || "$GP_MAJOR" == "7u" || "$GP_MAJOR" == "8u" ]]; then
    if make -C "$HOME/src/gpdb$GP_MAJOR/src/test/modules/dummy_seclabel" -j"$(nproc)" install; then
        BLDWRAP_POSTGRES_CONF_ADDONS="shared_preload_libraries='dummy_seclabel'"
#        BLDWRAP_POSTGRES_CONF_ADDONS="shared_preload_libraries='orca'"
    fi
fi
cd "$HOME/src/gpdb$GP_MAJOR"
export BLDWRAP_POSTGRES_CONF_ADDONS="$BLDWRAP_POSTGRES_CONF_ADDONS"
#export BLDWRAP_POSTGRES_CONF_ADDONS="gp_log_stack_trace_lines=false"
#export BLDWRAP_POSTGRES_CONF_ADDONS="gp_keep_all_xlog=true"
#export BLDWRAP_POSTGRES_CONF_ADDONS="wal_recycle=off"
#export BLDWRAP_POSTGRES_CONF_ADDONS="wal_debug=on"
make create-demo-cluster
createdb --owner="$USER" "$USER"
) 2>&1 | tee "$HOME/demo.log"
#source $HOME/src/gpdb$GP_MAJOR/gpAux/gpdemo/gpdemo-env.sh
