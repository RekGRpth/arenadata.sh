#!/bin/sh -eux

(
cd "$HOME/src/gpdb$GP_MAJOR/src/test/perl"
make -j$(nproc) install -i
) 2>&1 | tee "$HOME/perl.log"
