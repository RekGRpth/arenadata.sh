#!/bin/sh -eux

(
cd "$HOME/gpdb_src/src/test/modules/test_extensions"
make -j$(nproc) install
make -j$(nproc) installcheck -i
) 2>&1 | tee "$HOME/test_extensions.log"
