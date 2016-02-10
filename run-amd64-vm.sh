#!/bin/sh
sudo kvm \
    -m 512 \
    -nographic \
    -snapshot \
    -redir tcp:8022::22 \
    pc.img
