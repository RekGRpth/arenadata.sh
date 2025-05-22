#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR/src/pl/plpgsql"
make -j"$(nproc)" installcheck
) 2>&1 | tee "$HOME/plpgsql.log"
