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

# Add Regolith-desktop key and repo
wget -qO - https://regolith-desktop.org/regolith.key | \
gpg --dearmor | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg > /dev/null

echo deb "[arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
https://regolith-desktop.org/release-ubuntu-jammy-amd64 jammy main" | \
sudo tee /etc/apt/sources.list.d/regolith.list

# Update repos
sudo apt update

# Copy .zshrc before we install zsh to avoid intro guide
cp ~/dotfiles/.zshrc ~/.zshrc

# Download some packages we'll need
sudo apt install -y curl jq vim zsh fonts-noto-color-emoji

# Install ohmyzsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Regolith desktop if we haven't installed the Regolith ISO
if ! dpkg -l regolith-system 2&> /dev/null; then
	sudo apt install -y regolith-desktop
	sudo apt upgrade
fi

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

# Install Rust and cargo with rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install alactritty

# Install Ubuntu dependencies for alacritty
sudo apt install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3

# Install alacritty using cargo to get latest stable version
cargo install alacritty

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

git clone https://github.com/asdf-vm/asdf.git ~/.asdf
pushd ~/.asdf
git checkout "$(git describe --abbrev=0 --tags)"
popd

export PATH="$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH"

# Copy global ASDF tool-versions file
cp -R .tool-versions ~/

if [[ -f ~/.tool-versions ]]; then
  # Add plugin for each global tool
  awk '{print $1}' .tool-versions | xargs -I{} ~/.asdf/bin/asdf plugin add {}

  # Install ASDF tools
  ~/.asdf/bin/asdf install

  # Create the symlinks to binaries properly
  ~/.asdf/bin/asdf reshim
fi

# Aliases and misc stuff
git config --global alias.recent "for-each-ref --count=30 --sort=-committerdate refs/heads/ --format='%(refname:short)'"
git config --global url."git@github.com:".insteadOf https://github.com/
git config --global url."git://".insteadOf https://

# If kubectl is installed, add completions
if command -v kubectl; then
  sudo kubectl completion zsh > "${fpath[1]}/_kubectl"
fi

