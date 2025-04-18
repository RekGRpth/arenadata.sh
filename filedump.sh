#!/bin/sh -eux

(
cd "$HOME/src/pg_filedump"
make -j"$(nproc)" clean
make -j"$(nproc)" install
#cd "$HOME/src/filedump"
#make -j"$(nproc)" clean
#make -j"$(nproc)" -f Makefile.gpdb download
#make -j"$(nproc)" -f Makefile.gpdb
) 2>&1 | tee "$HOME/filedump.log"
