#!/bin/bash

# Make sure we're running as root
if [[ $(id -u) != 0 ]]; then
	echo "Need to run as root"
	exit 1
fi

# Add ppa for i3-regolith
add-apt-repository ppa:regolith-linux/release

# Add ppa for alacritty
add-apt-repository -y ppa:mmstick76/alacritty

# Download some
apt install curl jq git vim zsh regolith-desktop alacritty

# Put some regolith and i3 stuff in place
cp -R ./.config/i3-regolith /home/leo/.config/ 
cp -R ./i3blocks/i3blocks /usr/share/i3blocks
cp ./i3blocks/i3blocks.conf /etc/i3blocks.conf

# Copy Alacritty config
cp -R ./.config/alacritty /home/leo/.config/

# Bind Caps lock to ESC
setxkbmap -option caps:escape

cat << EOF > /etc/profile.d/02-caps-to-escape.sh
# /etc/profile.d/02-caps-to-escape.sh

# Bind escape to caps lock
setxkbmap -option caps:escape

EOF


# Set up oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git /home/leo/.oh-my-zsh
cp ./.zshrc /home/leo/.zshrc


# Install Antigen for Zsh plugin management
mkdir -p /home/leo/.oh-my-zsh/custom/tools
curl -L git.io/antigen > /home/leo/.oh-my-zsh/custom/tools/antigen.zsh

# Change default shell to ZSH
chsh -s /bin/zsh

# Download latest release of bat
pushd /tmp/
curl -s https://api.github.com/repos/sharkdp/bat/releases/latest \
| jq -r '.assets[] | select(.name | test("bat_.+_amd64.deb")) | .browser_download_url' \
| wget -qi -

dpkg -i bat_*_amd64.deb

popd

# Copy bat config and theme
cp -R ./.config/bat /home/leo/.config

# Update bat's binary cache with new Nord theme
bat cache --build

# Install ASDF
git clone https://github.com/asdf-vm/asdf.git /home/leo/.asdf
pushd /home/leo/.asdf
git checkout "$(git describe --abbrev=0 --tags)"
popd

# Copy global ASDF tool-versions file
cp -R ./.tool-versions /home/leo/

# Install ASDF tools
asdf install

# Aliases and misc stuff
git config --global alias.recent "for-each-ref --count=30 --sort=-committerdate refs/heads/ --format='%(refname:short)'"
kubectl completion zsh > "${fpath[1]}/_kubectl"

