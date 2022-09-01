#!/bin/bash

set -e

# These are the fonts from barista.run, copied from
# https://barista.run/pango/icons with the path modified.

mkdir ~/.config/regolith2/fonts
cd ~/.config/regolith2/fonts

# Material Design Icons
git clone --depth 1 https://github.com/google/material-design-icons
ln -s $PWD/material-design-icons/font/MaterialIcons-Regular.ttf ~/.fonts/

# Community Fork
git clone --depth 1 https://github.com/Templarian/MaterialDesign-Webfont
ln -s $PWD/MaterialDesign-Webfont/fonts/materialdesignicons-webfont.ttf ~/.fonts/

# FontAwesome
git clone --depth 1 https://github.com/FortAwesome/Font-Awesome
ln -s "$PWD/Font-Awesome/otfs/Font Awesome 5 Free-Solid-900.otf" ~/.fonts/
ln -s "$PWD/Font-Awesome/otfs/Font Awesome 5 Free-Regular-400.otf" ~/.fonts/
ln -s "$PWD/Font-Awesome/otfs/Font Awesome 5 Brands-Regular-400.otf" ~/.fonts/

# Typicons
git clone --depth 1 https://github.com/stephenhutchings/typicons.font
ln -s $PWD/typicons.font/src/font/typicons.ttf ~/.fonts/

# JetBrainsMono for Alacritty font
curl -s https://api.github.com/repos/JetBrains/JetBrainsMono/releases/latest \
| jq -r '.assets[] | select(.name | test("JetBrainsMono-.+.zip")) | .browser_download_url' \
| wget -qi -

# Refresh font cache
fc-cache -fv
