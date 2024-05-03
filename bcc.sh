#!/bin/sh -eux

(
#source scl_source enable llvm-toolset-11.0
#cd "$HOME/src/bcc/libbpf-tools"
cd "$HOME/src/bcc"
cmake3 . -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_VERBOSE_MAKEFILE=0 -DENABLE_TESTS=0 -DENABLE_LLVM_NATIVECODEGEN=0
#%make_build

#BUILD_STATIC_ONLY=y
#OBJDIR=build make install install_uapi_headers
#./configure
#make -j"$(nproc)" profile
#make -j"$(nproc)" offcputime
#make -j"$(nproc)" install
) 2>&1 | tee "$HOME/bcc.log"
