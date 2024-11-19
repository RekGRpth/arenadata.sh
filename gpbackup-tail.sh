#!/bin/sh -eux

tail -F .data/*/demoDataDir*/pg_log/*.csv gpAdminLogs/*.log 2>&1 | tee "$HOME/gpbackup-tail.log"
