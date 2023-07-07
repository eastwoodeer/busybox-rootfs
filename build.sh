export CROSS_COMPILE=~/Projects/toolchains/arm-gnu-toolchain-12.2.rel1-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
BUSYBOX_VERSION=1.36.1

wget -c https://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2
mkdir -p build
mv busybox-${BUSYBOX_VERSION}.tar.bz2 build/
cd build
tar jxf busybox-${BUSYBOX_VERSION}.tar.bz2
cd busybox-${BUSYBOX_VERSION}
make menuconfig
make && make install

cd _install
mkdir dev
sudo mknod dev/console c 5 1
sudo mknod dev/null c 1 3

TEMP_DIR=$(mktemp -d)
git clone https://github.com/eastwoodeer/busybox-rootfs.git ${TEMP_DIR}

pushd ${TEMP_DIR}
git checkout qemu
popd

mv ${TEMP_DIR}/etc .
rm -rf ${TEMP_DIR}

find . | cpio -o -H newc | gzip > ../../rootfs.cpio.gz
