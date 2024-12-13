#!/bin/sh -eux

clear
clear
tail -F .data/*/demoDataDir*/pg_log/*.csv .data/*/demoDataDir*/log/*.csv gpAdminLogs/*.log 2>&1 | tee "$HOME/gpbackup-tail.log"
