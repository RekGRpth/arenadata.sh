#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR/src/test/modules/test_extensions"
make -j$(nproc) install
make -j$(nproc) installcheck -i
) 2>&1 | tee "$HOME/test_extensions.log"
