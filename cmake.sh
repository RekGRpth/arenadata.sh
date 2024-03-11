#!/bin/sh -eux

(
curl -LJ https://github.com/Kitware/CMake/releases/download/v3.20.0/cmake-3.20.0-linux-x86_64.sh --output ./cmake-3.20.0-linux-x86_64.sh
sh cmake-3.20.0-linux-x86_64.sh --prefix="$PREFIX" --skip-license
rm cmake-3.20.0-linux-x86_64.sh
) 2>&1 | tee "$HOME/cmake.log"
