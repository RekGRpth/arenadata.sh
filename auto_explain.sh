#!/bin/bash -eux

exec 2>&1 &> >(tee "$HOME/auto_explain.log")

gpconfig -c shared_preload_libraries -v "$(psql -At -c "SELECT array_to_string(array_append(string_to_array(current_setting('shared_preload_libraries'), ','), 'auto_explain'), ',')" postgres)"
gpconfig -c auto_explain.log_analyze -v true --skipvalidation;
gpconfig -c auto_explain.log_min_duration -v 0 --skipvalidation;
gpconfig -c auto_explain.log_nested_statements -v true --skipvalidation;
gpconfig -c auto_explain.log_verbose -v true --skipvalidation;
gpstop -afr;
