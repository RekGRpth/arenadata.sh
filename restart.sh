#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR"
gpstop -afr
find "$DATADIRS" -name "gpbackup_*_script_*" -o -name "gpbackup_*_pipe_*" -o -name "gpbackup_*_skip_*" -o -name "gpbackup_*_oid_*" | while read name; do rm "$name"; done
) 2>&1 | tee "$HOME/restart.log"
