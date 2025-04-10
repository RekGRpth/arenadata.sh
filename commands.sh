#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR/src/backend/commands"
make -C test check
) 2>&1 | tee "$HOME/commands.log"
