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
cd "$HOME/src/gpdb$GP_MAJOR/contrib/dummy_seclabel"
make -j"$(nproc)" install
gpconfig -c shared_preload_libraries -v dummy_seclabel
gpstop -afr
) 2>&1 | tee "$HOME/demo.log"
