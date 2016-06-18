#!/bin/sh
# Run this script on an all-snap device to get quick-n-dirty version of the classic dimension
#
# USAGE:
# ./classic.py RELEASE_CODENAME
#
# You can choose any of the following codenames:
# devel, stable, LTS, yakkety, xenial, trusty
#
# The arguments are case-sensitive, so be wary


classic=$1

testcpu() {
    echo
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
}

prepare() {
    # There has to be an if/else statement here because the daily/yakkety .tar.gz URLs are different than the LTS URLs and it can't just be replaced with $classic
    if [ "$classic" = "yakkety" ] || [ "$classic" = "devel" ]; then
        classic=yakkety
        if [ ! -f "$classic-base-$arch.tar.gz" ]; then
            echo "Downloading $classic $arch classic base image..."
            python3 -c "from urllib.request import urlretrieve; urlretrieve('http://cdimage.ubuntu.com/ubuntu-base/daily/current/yakkety-base-$arch.tar.gz', '$classic-base-$arch.tar.gz')"
        fi

    # Technically, 16.04 is a stable release until 16.04.1 comes out, so let's give it the stable alias and Trusty the LTS alias.
    # When 16.04.1 gets released, remove the LTS alias from Trusty and add it on here.
    # When Yakkety gets released, remove the stable alias from Xenial and give Yakkety it's own elif between devel and LTS, that has the stable alias.
    # For future releases, you would just change the devel and stable aliases until Trusty goes EOL, then remove that. Once 18.04 is released, move Xenial to where Trusty is, and repeat the cycle.
    elif [ "$classic" = "xenial" ] || [ "$classic" = "stable" ]; then
        classic=xenial
        if [ ! -f "$classic-base-$arch.tar.gz" ]; then
            echo "Downloading $classic $arch classic base image..."
            python3 -c "from urllib.request import urlretrieve; urlretrieve('http://cdimage.ubuntu.com/ubuntu-base/$classic/daily/current/$classic-base-$arch.tar.gz', '$classic-base-$arch.tar.gz')"
        fi
      # python3 -c "from urllib.request import urlretrieve; urlretrieve('http://cdimage.ubuntu.com/ubuntu-base/releases/16.10/release/ubuntu-base-16.10-core-$arch.tar.gz', '$classic-base-$arch.tar.gz')"
    elif [ "$classic" = "trusty" ] || [ "$classic" = "LTS" ]; then
        classic=trusty
        if [ ! -f "$classic-base-$arch.tar.gz" ]; then
            echo "Downloading $classic $arch classic base image..."
            python3 -c "from urllib.request import urlretrieve; urlretrieve('http://cdimage.ubuntu.com/ubuntu-base/$classic/daily/current/$classic-base-$arch.tar.gz', '$classic-base-$arch.tar.gz')"
        fi
    fi

    if [ -f "$classic-base-$arch.tar.gz" ]; then
        mkdir "$classic"
        echo "Uncompressing $classic $arch classic base image..."
        tar -zxf "$classic-base-$arch.tar.gz" -C "$classic"
	echo "The image is uncompressed."
    fi
}

if [ "$(id -u)" -ne 0 ]; then
    echo "This script needs to run as root"
    exit 1
fi

if [ "$classic" = "yakkety" ] || [ "$classic" = "xenial" ] || [ "$classic" = "trusty" ]; then
    read -n1 -r -p "You have selected the $classic classic image. Press (y/n) to continue: " key
    if [ "$key" = 'y' ]; then
        testcpu
        prepare
    elif [ "$key" = 'n' ]; then
        exit 0
    else
        echo "Invalid key"
        exit 1
    fi
else
    case "$classic" in
        "devel")
            read -n1 -r -p "You have selected the Yakkety (devel) classic image. Press (y/n) to continue: " key
            if [ "$key" = 'y' ]; then
                testcpu
                prepare
            elif [ "$key" = 'n' ]; then
                exit 0
            else
                echo "Invalid key"
                exit 1
            fi
            ;;
        "stable")
            read -n1 -r -p "You have selected the Xenial (stable) classic image. Press (y/n) to continue: " key
            if [ "$key" = 'y' ]; then
                testcpu
                prepare
            elif [ "$key" = 'n' ]; then
                exit 0
            else
                echo "Invalid key"
                exit 1
            fi
            ;;
        "LTS")
            read -n1 -r -p "You have selected the Trusty (LTS) classic image. Press (y/n) to continue: " key
            if [ "$key" = 'y' ]; then
                testcpu
                prepare
            elif [ "$key" = 'n' ]; then
                exit 0
            else
                echo "Invalid key"
                exit 1
            fi
            ;;
        *)
            echo "Error, invalid release codename."
            echo
            echo "USAGE:"
            echo "./classic.py RELEASE_CODENAME"
            echo
            echo "You can choose any of the following codenames:"
            echo "devel, stable, LTS, yakkety, xenial, trusty"
            echo
            echo "The arguments are case-sensitive, so be wary"
            ;;
        esac
fi

cleanup() {
    umount -l $classic/home
    umount -l $classic/sys
    umount -l $classic/dev/pts
    umount -l $classic/dev
    umount -l $classic/proc
}

trap "cleanup" EXIT
echo "Mounting $classic/proc"
mount --bind /proc $classic/proc
echo "Mounted $classic/proc"
echo "Mounting $classic/dev"
mount --bind /dev $classic/dev
echo "Mounted $classic/dev"
echo "Mounting $classic/sys"
mount --bind /sys $classic/sys
echo "Mounted $classic/sys"
echo "Mounting $classic/home"
mount --bind /home $classic/home
echo "Mounted $classic/home"
echo "Mounting $classic/dev/pts"
mkdir -pv $classic/dev/pts
mount -t devpts none $classic/dev/pts
echo "Mounted $classic/dev/pts"
echo "Copying resolv.conf to $classic/etc"
cp -v /etc/resolv.conf $classic/etc
echo "Entering $classic/"
chroot $classic/
