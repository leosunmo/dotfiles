#!/bin/bash

# Make sure we're running as root
if [[ $(id -u) != 0 ]]; then
	echo "Need to run as root"
	exit 1
fi

# Add ppa for i3-regolith
add-apt-repository -y ppa:/kgilmer/regolith-stable

# Add ppa for alacritty
add-apt-repository -y ppa:mmstick76/alacritty

# Download some
apt install curl jq git vim zsh regolith-desktop alacritty

# Put some regolith and i3 stuff in place
cp -R ./.config/i3-regolith ~/.config/ 
cp -R ./i3blocks/i3blocks /usr/share/i3blocks
cp ./i3blocks/i3blocks.conf /etc/i3blocks.conf

# Bind Caps lock to ESC
setxkbmap -option caps:escape

cat << EOF > /etc/profile.d/02-caps-to-escape.sh
# /etc/profile.d/02-caps-to-escape.sh

# Bind escape to caps lock
setxkbmap -option caps:escape

EOF


# Set up oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ./.zshrc ~/.zshrc


# Install Antigen for Zsh plugin management
mkdir -p ~/.oh-my-zsh/custom/tools
curl -L git.io/antigen > ~/.oh-my-zsh/custom/tools/antigen.zsh

# Change default shell to ZSH
chsh -s /bin/zsh

# Install some applications

# Download and install latest playerctl

pushd /tmp/
curl -s https://api.github.com/repos/acrisci/playerctl/releases/latest \
| jq -r '.assets[] | select(.name | test("playerctl.+_amd64.deb")) | .browser_download_url' \
| wget -qi -

dpkg -i playerctl*_amd64.deb

popd

# Download latest release of bat
pushd /tmp/
curl -s https://api.github.com/repos/sharkdp/bat/releases/latest \
| jq -r '.assets[] | select(.name | test("bat_.+_amd64.deb")) | .browser_download_url' \
| wget -qi -

dpkg -i bat_*_amd64.deb

popd

# Copy bat config and theme
cp -R ./.config/bat ~/.config

# Update bat's binary cache with new Nord theme
bat cache --build


# Install Kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.14.0/bin/linux/amd64/kubectl


# Install Krew (Kubectl plugin manager)
(
  set -x; cd "$(mktemp -d)" &&
  curl -fsSLO "https://storage.googleapis.com/krew/v0.2.1/krew.{tar.gz,yaml}" &&
  tar zxvf krew.tar.gz &&
  ./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64" install \
    --manifest=krew.yaml --archive=krew.tar.gz
)
# Aliases and misc stuff
git config --global alias.recent "for-each-ref --count=30 --sort=-committerdate refs/heads/ --format='%(refname:short)'"
kubectl completion zsh > "${fpath[1]}/_kubectl"

