#!/bin/bash

# Make sure we're running as root
if [[ $(id -u) != 0 ]]; then
	echo "Need to run as root"
	exit 1
fi

# Download some stuff we'll need and use often
apt install curl jq git vim zsh


# Bind Caps lock to ESC
setxkbmap -option caps:escape

cat << EOF >> /etc/profile.d/02-caps-to-escape.sh
# /etc/profile.d/02-caps-to-escape.sh

# Bind escape to caps lock
setxkbmap -option caps:escape

EOF

# Set up oh-my-zsh
# This has to happen last as it kicks us in to a ZSH shell and aborts the rest of the script
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
