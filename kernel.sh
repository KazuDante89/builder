#!/bin/bash

# Export environment variables
export DATE=$(date +"%d-%m-%Y-%I-%M")
export TC_DIR=$(pwd)/clang
export PATH="$TC_DIR/bin:$PATH"
export CLANG_TRIPLE=aarch64-linux-gnu
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu
export CROSS_COMPILE_ARM32=arm-linux-gnueabi
export LD_LIBRARY_PATH=$TC_DIR/lib
export KBUILD_BUILD_USER="KazuDante"
export KBUILD_BUILD_HOST="Machine"
export USE_HOST_LEX=yes
export KERNEL_IMG=out/arch/arm64/boot/Image
export KERNEL_DTBO=out/arch/arm64/boot/dts/vendor/qcom/lisa-sm7325-overlay.dtbo
export KERNEL_DTB=out/arch/arm64/boot/dts/vendor/qcom/yupik.dtb
export DEFCONFIG=lisa_defconfig
export ANYKERNEL_DIR=$(pwd)/AnyKernel3
export THREADS=-j$(nproc --all)
export LLVM=1
export O=out

# Cleanup
rm -rf "$O"
rm -rf "$ANYKERNEL_DIR"

# Clone dependencies
git clone --depth 1 https://gitlab.com/ThankYouMario/android_prebuilts_clang-standalone.git -b 15 "$TC_DIR"
git clone --depth 1 http://github.com/KazuDante89/AnyKernel3.git "$ANYKERNEL_DIR"

# Make defconfig
make $DEFCONFIG $THREADS CC=clang LD=ld.lld AS=llvm-as AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip O=out/ 2>&1 | tee log.txt

# Make kernel
make $THREADS CC=clang LD=ld.lld AS=llvm-as AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip O=out/ 2>&1 | tee log.txt

# Check if Image.gz exists. If not, stop executing.
if ! [ -a $KERNEL_IMG ];
  then
    echo "An error has occured during compilation. Please check your code."
    cat log.txt | grep "error:"
    exit 1
  fi

# Make flashable zip
cp "$KERNEL_IMG" "$ANYKERNEL_DIR"
cp "$KERNEL_DTB" "$ANYKERNEL_DIR"
cp "$KERNEL_DTBO" "$ANYKERNEL_DIR"
cd "$ANYKERNEL_DIR"
ZIPNAME="Phantom-lisa-$(date '+%d%m%Y-%H%M').zip"
zip -r9 "$ZIPNAME" * -x LICENSE README.md
