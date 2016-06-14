#!/bin/sh
# Run this script on an all-snap device to get quick-n-dirty version of the classic dimension

if [ "$(id -u)" -ne 0 ]; then
    echo "This script needs to run as root"
    exit 1
fi
case "$(uname -m)" in
    i686)
        arch=i386
        ;;
    x86_64)
        arch=amd64
        ;;
    armv7l)
        arch=armhf
        ;;
    aarch64)
        arch=arm64
        ;;
    *)
        echo "Unsupported architecture!"
        exit 1
        ;;
esac

if [ ! -f "classic-base-$arch.tar.gz" ]; then
    if [[ "$DEVEL" == "yes" ]]; then
        echo "Downloading Ubuntu 16.10 (Development Branch) $arch Classic Base image..."
        python3 -c "from urllib.request import urlretrieve; urlretrieve('http://cdimage.ubuntu.com/ubuntu-base/daily/current/yakkety-base-$arch.tar.gz', 'classic-base-$arch.tar.gz')"
    else
        echo "Downloading Ubuntu 16.04 LTS $arch Classic Base image..."
	python3 -c "from urllib.request import urlretrieve; urlretrieve('http://cdimage.ubuntu.com/ubuntu-base/xenial/daily/current/xenial-base-$arch.tar.gz', 'classic-base-$arch.tar.gz')"
    fi
fi

if [ -f "classic-base-$arch.tar.gz" ]; then
    mkdir classic
    echo "Uncompressing Classic Base image..."
    tar -zxfv "classic-base-$arch.tar.gz" -C xenial
fi

cleanup() {
    umount -l classic/home
    umount -l classic/sys
    umount -l classic/dev/pts
    umount -l classic/dev
    umount -l classic/proc
}

trap "cleanup" EXIT
mount --bind /proc classic/proc
mount --bind /dev classic/dev
mount --bind /sys classic/sys
mount --bind /home classic/home
mkdir -p classic/dev/pts
mount -t devpts none classic/dev/pts

cp /etc/resolv.conf classic/etc

echo "Entering Classic image"

chroot classic/
