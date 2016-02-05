#!/bin/sh
set -x
set -e
# Defaults
export GOARCH=amd64
SNAPPY_HOST=snappy-vm
# CLI
while [ "$1" != '' ]; do
    case $1 in
        --vm)
            SNAPPY_HOST=snappy-vm
            export GOARCH=amd64
            ;;
        --bbb)
            SNAPPY_HOST=snappy-bbb
            export GOARCH=arm
            export GOARM=7
            export CGO_ENABLED=1
            export CC=arm-linux-gnueabihf-gcc
            shift
            ;;
        --rpi2)
            SNAPPY_HOST=snappy-rpi2
            export GOARCH=arm
            export GOARM=7
            export CGO_ENABLED=1
            export CC=arm-linux-gnueabihf-gcc
            shift
            ;;
        --arm)
            shift
            export GOARCH=arm
            export GOARM=7
            export CGO_ENABLED=1
            export CC=arm-linux-gnueabihf-gcc
            ;;
        snap|snappy)
            go build -o $1.$GOARCH github.com/ubuntu-core/snappy/cmd/$1
            scp $1.$GOARCH $SNAPPY_HOST:$1
            shift
            ;;
        snapd)
            go build -o $1.$GOARCH github.com/ubuntu-core/snappy/cmd/$1
            ssh $SNAPPY_HOST sudo pkill snapd || :
            scp $1.$GOARCH $SNAPPY_HOST:$1
            shift
            ;;
        setup)
            echo "Disabling normal snap daemon..."
            ssh $SNAPPY_HOST sudo systemctl disable ubuntu-snappy.snapd.socket
            ssh $SNAPPY_HOST sudo systemctl disable ubuntu-snappy.snapd.service
            ssh $SNAPPY_HOST sudo systemctl stop ubuntu-snappy.snapd.socket
            ssh $SNAPPY_HOST sudo systemctl stop ubuntu-snappy.snapd.service
            echo "Killing any locally-started snapd"
            ssh $SNAPPY_HOST sudo pkill snapd || :
            echo "Inspecting VM state"
            ssh $SNAPPY_HOST systemctl status ubuntu-snappy.snapd.{socket,service} || :
            shift
            ;;
        run-snapd)
            ssh $SNAPPY_HOST sudo /lib/systemd/systemd-activate -l /run/snapd.socket ./snapd 
            shift
            ;;
        *)
            echo "Unknown command: $1"
            exit 1
            ;;
    esac
done
