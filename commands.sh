#!/bin/sh -eux

(
cd "$HOME/gpdb_src/src/backend/commands"
make -C test check
) 2>&1 | tee "$HOME/commands.log"
