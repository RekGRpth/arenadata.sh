#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR"
gpstop -afr
) 2>&1 | tee "$HOME/restart.log"
