#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR"
git apply "$(dirname "$0")/format.diff"
#export CLANG_FORMAT=clang-format-11
#export CLANG_FORMAT=clang-format
#src/tools/fmt gen
#src/tools/fmt chk
src/tools/fmt fmt
git apply "$(dirname "$0")/format-revert.diff"
) 2>&1 | tee "$HOME/format.log"

#CLANG_FORMAT=clang-format-11 src/tools/fmt fmt
