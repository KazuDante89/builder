#!/bin/bash

###############################   MISC   ###################################

	gut() {
		git clone --depth=1 -q "$@"
	}

############################################################################

######################## Setup Telegram API ################################
	if [[ ! $(which telegram-send) ]]; then
		pip3 -q install telegram-send
	fi
	sed -i s/demo1/"${BOT_API_KEY}"/g telegram-send.conf
	sed -i s/demo2/"${CHAT_ID}"/g telegram-send.conf
	mkdir "$HOME"/.config
	curl -o telegram-send.conf https://raw.githubusercontent.com/KazuDante89/builder/main/telegram-send.conf
	mv telegram-send.conf "$HOME"/.config/telegram-send.conf

############################################################################

############################## Setup Toolchains ############################
	toolchains_setup() {
		if [[ ! -d /usr/$1 ]]; then
			gut "$3" -b "$4" "$2"
		else
			ln -s /usr/"$1" "$2"
		fi
	}

        mkdir Kernel
	mkdir toolchains
	toolchains_setup gcc64 toolchains/gcc-arm64 https://github.com/mvaisakh/gcc-arm64 gcc-master
	toolchains_setup gcc32 toolchains/gcc-arm https://github.com/mvaisakh/gcc-arm gcc-master
	toolchains_setup clang toolchains/clang https://gitlab.com/dakkshesh07/neutron-clang Neutron-16
############################################################################

############################## Setup AnyKernel #############################

	gut https://github.com/KazuDante89/AnyKernel3 -b main AnyKernel3

############################################################################

############################## Setup Kernel ################################

	gut https://github.com/KazuDante89/android_kernel_lisa -b sapphire Kernel

############################################################################

############################ Setup Scripts #################################

curl -o build.sh https://raw.githubusercontent.com/KazuDante89/builder/main/build.sh
cp build.sh Kernel/build.sh
cd Kernel || exit
bash build.sh --compiler=clang --device=lisa
exit 0
