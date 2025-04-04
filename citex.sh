#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR/contrib/citext"
make -j"$(nproc)" installcheck
) 2>&1 | tee "$HOME/citext.log"
