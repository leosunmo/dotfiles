#!/bin/bash

# Make sure we're not running as root
if [[ $(id -u) == 0 ]]; then
	echo "Should not be run as root, it will prompt when needed"
	exit 1
fi

TERM_CHOICE="ghostty"
GO_VERSION="1.24.1"
ASDF_VERSION="0.16.0"

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
wget -qO - https://archive.regolith-desktop.com/regolith.key | \
gpg --dearmor | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg > /dev/null

echo deb "[arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
https://archive.regolith-desktop.com/ubuntu/stable noble v3.2" | \
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
	sudo apt install -y regolith-desktop regolith-session-flashback regolith-session-sway regolith-look-nord
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

# Install extra drivers if we use a Tiger Lake intel audio driver
if lspci -nnk | grep -A2 Audio | grep 'Kernel driver in use:' | grep -q sof; then
sudo apt install -y firmware-sof-signed
fi


# Install Go
pushd /tmp/
wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
rm go${GO_VERSION}.linux-amd64.tar.gz
popd

# Install Rust and cargo with rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

case "$TERM_CHOICE" in
  "alacritty")
    # Install Ubuntu dependencies for alacritty
    sudo apt install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3

    # Install alacritty using cargo to get latest stable version
    cargo install alacritty
    ;;
  "ghostty")
    # Install ghostty
    # A bit sketch with a install.sh, but I'd be blindly downloading latest release anyway...
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"

    # Put ghostty config in place
    cp -R ~/dotfiles/.config/ghostty ~/.config
    ;;
  *)
    echo "Invalid terminal choice"
    ;;
esac

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

# Install asdf
go install github.com/asdf-vm/asdf/cmd/asdf@v${ASDF_VERSION}

# Copy global ASDF tool-versions file
cp -R .tool-versions ~/

if [[ -f ~/.tool-versions ]]; then
  # Add plugin for each global tool
  awk '{print $1}' .tool-versions | xargs -I{} ~/.asdf/bin/asdf plugin add {}

  # Install ASDF tools
  asdf install

  # Create the symlinks to binaries properly
  asdf reshim
fi

# Aliases and misc stuff
git config --global alias.recent "for-each-ref --count=30 --sort=-committerdate refs/heads/ --format='%(refname:short)'"
git config --global url."git@github.com:".insteadOf https://github.com/
git config --global url."git://".insteadOf https://
git config --global core.editor "vim"


# If kubectl is installed, add completions
if command -v kubectl; then
  sudo kubectl completion zsh > "${fpath[1]}/_kubectl"
fi

# Change default shell to ZSH
chsh -s /usr/bin/zsh
