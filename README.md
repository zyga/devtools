# Snappy Development Tools

This repository holds my personal snappy development tools.  Improvements are
welcome, just shoot merge requests at me.

My work-flow involves using a checkout of github.com/ubuntu-core/snappy in my $GOPATH,
building and testing various parts of snappy during daily development.

For on-device testing I use the ``ubuntu-image`` script to build development
images. Once a device is "flashed" it can stay up indefinitely. Devices that
don't have automatic update available need to be re-flashed periodically, as
updates are rolled out.

For on-VM testing I use ``ubuntu-image --developer-mode pc`` along with
``run-pc-devel-vm``. The VM can be killed at any time, nothing that is changed
in the VM is persistent.

In both cases I use the ``refresh-bits.sh`` script to push new, ``snap``,
``snapd`` and ``snappy`` (deprecated) binaries over. This requires a certain SSH setup:

Put something similar to your ``~/.ssh/config`` file. Do change ``bbb-1.lan``
and ``pi2-1.lan`` to an appropriate hostname (or IP address) that is valid in
your setup.

```
Host snappy-vm
    HostName localhost
    Port 8022
    User ubuntu
    KbdInteractiveAuthentication no
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    IdentityFile ~/.ssh/id_rsa

Host snappy-bbb
    HostName bbb-1.lan
    User ubuntu
    KbdInteractiveAuthentication no
    StrictHostKeyChecking no
    IdentityFile ~/.ssh/id_rsa

Host snappy-rpi2
    HostName pi2-1.lan
    User ubuntu
    KbdInteractiveAuthentication no
    StrictHostKeyChecking no
    IdentityFile ~/.ssh/id_rsa
```
