#!/bin/bash

# Make sure we're not running as root
if [[ $(id -u) == 0 ]]; then
	echo "Should not be run as root, it will prompt when needed"
	exit 1
fi

if ! [ -x "$(command -v git)" ]; then
	echo "Can't find git, installing it..."
	sudo apt install -y git
fi

if [[ ! -d ~/dotfiles ]]; then
	git clone https://github.com/leosunmo/dotfiles.git ~/dotfiles
fi

# Make sure we're in the dotfiles directory
cd ~/dotfiles

# Add ppa for i3-regolith
sudo add-apt-repository -y ppa:regolith-linux/release

# Add ppa for alacritty
sudo add-apt-repository -y ppa:mmstick76/alacritty

# Copy .zshrc before we install zsh to avoid intro guide
cp ~/dotfiles/.zshrc ~/.zshrc

# Download some packages we'll need
sudo apt install curl jq vim zsh regolith-desktop alacritty

# Install Antibody zsh plugin manager
curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin

# Copy Antibody zsh_plugins
cp .zsh_plugins.txt ~/.zsh_plugins.txt

# Put some regolith and i3 stuff in place
cp -R ~/dotfiles/.config/regolith ~/.config/

# Copy Alacritty config
cp -R ~/dotfiles/.config/alacritty ~/.config/

# Bind Caps lock to ESC
setxkbmap -option caps:escape

# Sudo with a subshell since the redirection is performed before
# the permissions have been elevated.
sudo sh -c ' cat << EOF > /etc/profile.d/02-caps-to-escape.sh
# /etc/profile.d/02-caps-to-escape.sh

# Bind escape to caps lock
setxkbmap -option caps:escape

EOF'

# Change default shell to ZSH
chsh -s /bin/zsh

# Download latest release of bat
pushd /tmp/
curl -s https://api.github.com/repos/sharkdp/bat/releases/latest \
| jq -r '.assets[] | select(.name | test("bat_.+_amd64.deb")) | .browser_download_url' \
| wget -qi -

sudo dpkg -i bat_*_amd64.deb

popd

# Copy bat config and theme
cp -R ~/dotfiles/.config/bat ~/.config

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
awk '{print $1}' .tool-versions | xargs -I{} ~/.asdf/bin/asdf plugin add {}

# Install ASDF tools
~/.asdf/bin/asdf install

# Create the symlinks to binaries properly
~/.asdf/bin/asdf reshim

# Aliases and misc stuff
git config --global alias.recent "for-each-ref --count=30 --sort=-committerdate refs/heads/ --format='%(refname:short)'"
sudo kubectl completion zsh > "${fpath[1]}/_kubectl"

