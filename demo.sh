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
cd "$HOME/src/gpdb$GP_MAJOR"
make create-demo-cluster
if [ "$GP_MAJOR" -eq "6" ]; then
    make -C "$HOME/src/gpdb$GP_MAJOR/contrib/dummy_seclabel" -j"$(nproc)" install
#    cd "$HOME/src/gpdb$GP_MAJOR/contrib/dummy_seclabel"
#    make -j"$(nproc)" install
    gpconfig -c shared_preload_libraries -v dummy_seclabel
    gpstop -afr
elif [ "$GP_MAJOR" -eq "7" ]; then
    make -C "$HOME/src/gpdb$GP_MAJOR/src/test/modules/dummy_seclabel" -j"$(nproc)" install
#    cd "$HOME/src/gpdb$GP_MAJOR/contrib/dummy_seclabel"
#    make -j"$(nproc)" install
    gpconfig -c shared_preload_libraries -v dummy_seclabel
    gpstop -afr
fi
createdb --owner="$USER" "$USER"
) 2>&1 | tee "$HOME/demo.log"
#source $HOME/src/gpdb$GP_MAJOR/gpAux/gpdemo/gpdemo-env.sh
