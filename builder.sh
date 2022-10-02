#!/bin/bash

###############################   MISC   ###################################

gut() {
	git clone --depth=1 -q $@
}

############################################################################


############################# Setup Toolchains #############################

mkdir toolchains

#gut https://github.com/cyberknight777/gcc-arm64.git -b master toolchains/gcc64
gut https://github.com/cyberknight777/gcc-arm.git -b master toolchains/gcc32
gut https://gitlab.com/dakkshesh07/neutron-clang.git -b Neutron-16 toolchains/clang

############################################################################

############################## Setup AnyKernel #############################

gut https://github.com/KazuDante89/AnyKernel3.git AnyKernel3

############################################################################

############################### Setup Kernel ###############################

gut https://github.com/KazuDante89/xiaomi_lisa_kernel.git -b Lab Kernel

############################################################################

############################## Setup Scripts ###############################

mv lab.sh Kernel/lab.sh
cd Kernel
bash lab.sh clang
