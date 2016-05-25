#!/bin/sh
# Run this script on an all-snap device to get quick-n-dirty version of the classic dimension

if [ "$(id -u)" -ne 0 ]; then
    echo "this script needs to run as root"
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

if [ ! -f "xenial-base-$arch.tar.gz" ]; then
    echo "Downloading xenial chroot for $arch..."
    python3 -c "from urllib.request import urlretrieve; urlretrieve('http://cdimage.ubuntu.com/ubuntu-base/xenial/daily/current/xenial-base-$arch.tar.gz', 'xenial-base-$arch.tar.gz')"
fi

if [ ! -d xenial ]; then
    mkdir xenial
    echo "Uncompressing xenial chroot..."
    tar -zxf "xenial-base-$arch.tar.gz" -C xenial
fi

cleanup() {
    umount -l xenial/home
    umount -l xenial/sys
    umount -l xenial/dev/pts
    umount -l xenial/dev
    umount -l xenial/proc
}

trap "cleanup" EXIT
mount --bind /proc xenial/proc
mount --bind /dev xenial/dev
mount --bind /sys xenial/sys
mount --bind /home xenial/home
mkdir -p xenial/dev/pts
mount -t devpts none xenial/dev/pts

cp /etc/resolv.conf xenial/etc

chroot xenial/
