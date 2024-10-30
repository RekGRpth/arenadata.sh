#!/bin/sh -eux

(
cd "$HOME/src/diskquota"
git ls-files '*.c' '*.h' | xargs clang-format-13 --style=file -i
) 2>&1 | tee "$HOME/diskquota-format.log"
