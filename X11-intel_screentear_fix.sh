#!/bin/bash

# Make sure we're running as root
if [[ $(id -u) != 0 ]]; then
        echo "Need to run as root"
        exit 1
fi

mkdir -p /etc/X11/xorg.conf.d

cat << EOF > /etc/X11/xorg.conf.d/20-intel-graphics.conf
Section "Device"
   Identifier  "Intel Graphics"
   Driver      "intel"
   Option      "TripleBuffer" "true"
   Option      "TearFree"     "true"
EndSection

EOF
