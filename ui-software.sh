#!/bin/bash

## gui/tui software
sudo pacman -S \
    kitty \
    arc-gtk-theme noto-fonts-emoji \
    zathura zathura-pdf-mupdf \
    mpv yt-dlp \
    ncmpcpp mpc mopidy pavucontrol \
    neomutt urlscan elinks signal-desktop \
    qutebrowser libpipewire02 python-adblock pdfjs qt5-wayland python-tldextract

yay -S gomuks libspotify syncplay

# mopidy plugins
sudo python3 -m pip install Mopidy-Spotify Mopidy-Subidy Mopidy-MPD

# link config
for config in fontconfig kitty mopidy mpv mutt ncmpcpp qutebrowser zathura pavucontrol.ini syncplay.ini
do
    rm -rf ~/.config/$config
    ln -s ~/dotfiles/.config/$config ~/.config/$config
done

# create cache directory
mkdir -p ~/.cache/mutt

# set qutebrowser to be our default browser
xdg-settings set default-web-browser org.qutebrowser.qutebrowser.desktop
xdg-mime default org.qutebrowser.qutebrowser.desktop x-scheme-handler/https x-scheme-handler/http
