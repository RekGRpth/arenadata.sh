#!/bin/sh -eux

(
cd "$HOME/src/pgbackrest/src"
./configure --prefix="$HOME/.local$GP_MAJOR"
make -j"$(nproc)" install
) 2>&1 | tee "$HOME/pgbackrest.log"
