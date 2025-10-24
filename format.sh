#!/bin/bash -eux

(
cd "$HOME/gpdb_src"
if [[ "$GP_MAJOR" == "6c" ]]; then
    source scl_source enable llvm-toolset-11.0
    git apply "$(dirname "$0")/format.diff"
fi
#export CLANG_FORMAT=clang-format-11
#export CLANG_FORMAT=clang-format
#src/tools/fmt gen
#src/tools/fmt chk
#src/tools/fmt fmt
CLANG_FORMAT=clang-format-11 src/tools/fmt fmt
if [[ "$GP_MAJOR" == "6c" ]]; then
    git apply "$(dirname "$0")/format-revert.diff"
fi
) 2>&1 | tee "$HOME/format.log"

#CLANG_FORMAT=clang-format-11 src/tools/fmt fmt
