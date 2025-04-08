#!/bin/bash

set -ex

# These are the fonts from barista.run, copied from
# https://barista.run/pango/icons with the path modified.

mkdir -p  ~/.config/gobar/fonts
mkdir -p ~/.fonts
cd ~/.config/gobar/fonts

# # Material Design Icons
# git clone --depth 1 https://github.com/google/material-design-icons
# ln -s $PWD/material-design-icons/font/MaterialIcons-Regular.ttf ~/.fonts/

# Material Design Symbols
wget -qO ~/.config/gobar/fonts/MaterialSymbolsOutlined.codepoints https://raw.githubusercontent.com/google/material-design-icons/refs/heads/master/variablefont/MaterialSymbolsOutlined%5BFILL%2CGRAD%2Copsz%2Cwght%5D.codepoints
wget -qO ~/.fonts/MaterialSymbolsOutlined.ttf https://raw.githubusercontent.com/google/material-design-icons/refs/heads/master/variablefont/MaterialSymbolsOutlined%5BFILL%2CGRAD%2Copsz%2Cwght%5D.ttf

# # Community Fork
# git clone --depth 1 https://github.com/Templarian/MaterialDesign-Webfont
# ln -s $PWD/MaterialDesign-Webfont/fonts/materialdesignicons-webfont.ttf ~/.fonts/

# # FontAwesome
# git clone --depth 1 https://github.com/FortAwesome/Font-Awesome
# ln -s "$PWD/Font-Awesome/otfs/Font Awesome 5 Free-Solid-900.otf" ~/.fonts/
# ln -s "$PWD/Font-Awesome/otfs/Font Awesome 5 Free-Regular-400.otf" ~/.fonts/
# ln -s "$PWD/Font-Awesome/otfs/Font Awesome 5 Brands-Regular-400.otf" ~/.fonts/

# # Typicons
# git clone --depth 1 https://github.com/stephenhutchings/typicons.font
# ln -s $PWD/typicons.font/src/font/typicons.ttf ~/.fonts/

# JetBrainsMono for Alacritty font
# Download to temporary file, unzip,
# copy to ~/.fonts and remove it
dir=$(mktemp -d jetbrainsmono.XXXXXX -p /tmp)
pushd $dir
curl -s https://api.github.com/repos/JetBrains/JetBrainsMono/releases/latest \
| jq -r '.assets[] | select(.name | test("JetBrainsMono-.+.zip")) | .browser_download_url' \
| wget -qi -

unzip JetBrainsMono-*.zip
cp fonts/ttf/*.ttf ~/.fonts/

popd
rm -rf $dir

# Refresh font cache
fc-cache -fv
