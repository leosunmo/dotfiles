#!/bin/bash

# Make sure we're not running as root
if [[ $(id -u) == 0 ]]; then
	echo "Should not be run as root, it will prompt when needed"
	exit 1
fi

# Add ppa for i3-regolith
sudo add-apt-repository ppa:regolith-linux/release

# Add ppa for alacritty
sudo add-apt-repository -y ppa:mmstick76/alacritty

# Copy .zshrc before we install zsh to avoid intro guide
cp .zshrc ~/.zshrc

# Download some packages we'll need
sudo apt install curl jq git vim zsh regolith-desktop alacritty

# Put some regolith and i3 stuff in place
cp -R .config/i3-regolith ~/.config/ 
cp -R i3blocks/i3blocks /usr/share/i3blocks
cp i3blocks/i3blocks.conf /etc/i3blocks.conf

# Copy Alacritty config
cp -R .config/alacritty ~/.config/

# Bind Caps lock to ESC
setxkbmap -option caps:escape

# Sudo with a subshell since the redirection is performed before
# the permissions have been elevated.
sudo sh -c ' cat << EOF > /etc/profile.d/02-caps-to-escape.sh
# /etc/profile.d/02-caps-to-escape.sh

# Bind escape to caps lock
setxkbmap -option caps:escape

EOF'

# Set up oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

# Install Antigen for Zsh plugin management
mkdir -p ~/.oh-my-zsh/custom/tools
curl -L git.io/antigen > ~/.oh-my-zsh/custom/tools/antigen.zsh

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
cp -R .config/bat ~/.config

# Update bat's binary cache with new Nord theme
bat cache --build

# Install ASDF
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
pushd ~/.asdf
git checkout "$(git describe --abbrev=0 --tags)"
popd

# Copy global ASDF tool-versions file
cp -R .tool-versions ~/

# Add plugin for each global tool
awk '{print $1}' .tool-versions | xargs -I{} asdf plugin add {}

# Install ASDF tools
~/.asdf/bin/asdf install

# Aliases and misc stuff
git config --global alias.recent "for-each-ref --count=30 --sort=-committerdate refs/heads/ --format='%(refname:short)'"
kubectl completion zsh > "${fpath[1]}/_kubectl"

