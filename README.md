# Snappy Development Tools

This repository holds my personal snappy development tools.  Improvements are
welcome, just shoot merge requests at me.

My work-flow involves using a checkout of http://github.com/snapcore/snapd
in my ``$GOPATH``, building and testing various parts of snappy during daily
development.

## Working with developer boards and VMs

For on-device testing I use the ``ubuntu-image`` script to build development
images. Once a device is "flashed" it can stay up indefinitely. Devices that
don't have automatic update available need to be re-flashed periodically, as
updates are rolled out.

For on-VM testing I use ``ubuntu-image --developer-mode pc`` along with
``run-devel-vm pc``. The VM can be killed at any time, nothing that is changed
in the VM is persistent.

In both cases I use the ``refresh-bits`` script to push new, ``snap``,
``snapd`` and ``snappy`` (deprecated) binaries over. This requires a certain
SSH setup:

## SSH configuration

If you are going to use any remote machines please ensure that you can connect
to them with SSH without a password prompt. In addition you should not need a
password to use sudo.
