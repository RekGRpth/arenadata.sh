#!/bin/sh -eux

(
#source scl_source enable llvm-toolset-11.0
cd "$HOME/src/c-bpf"
#BUILD_STATIC_ONLY=y
#OBJDIR=build make install install_uapi_headers
#./configure
make -j"$(nproc)" clean
make -j"$(nproc)"
#make -j"$(nproc)" install
#make
) 2>&1 | tee "$HOME/c-bpf.log"
