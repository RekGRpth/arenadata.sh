#!/bin/sh -eux

(
#source scl_source enable llvm-toolset-11.0
cd "$HOME/src/libbpf/src"
#BUILD_STATIC_ONLY=y
#OBJDIR=build make install install_uapi_headers
#./configure
make -j"$(nproc)"
make -j"$(nproc)" install
) 2>&1 | tee "$HOME/libbpf.log"
