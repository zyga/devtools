# devtoools
My personal snappy development tools.

Improvements are welcome, just shoot merge requests at me.

This directory relies on fresh ```ubuntu-device-flash``` from http://people.canonical.com/~mvo/all-snaps/

I used something like this to create an image:
```
sudo ubuntu-device-flash core rolling \
 --oem generic-amd64.canonical \
 --output ubuntu-snappy-edge-amd64.img \
 --channel edge --size 4 \
 --developer-mode --enable-ssh
```

This is important because kvm is restarted all the time (without preserving changes) and the your key really has to be inside for this to work. This why you want to generate an image yourself.
