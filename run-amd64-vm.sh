#!/bin/sh
if [ ! -e pc-devel.img ]; then
    echo "Please make a development PC image first:"
    echo "$ ./ubuntu-image --developer-mode pc"
    exit 1
fi
sudo kvm \
    -m 512 \
    -nographic \
    -snapshot \
    -redir tcp:8022::22 \
    pc-devel.img
