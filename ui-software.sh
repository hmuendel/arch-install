#!/bin/bash

## gui/tui software
sudo pacman -S \
    kitty \
    mpv pavucontrol arc-gtk-theme zathura zathura-pdf-mupdf \
    ncmpcpp mpc mopidy \
    neomutt signal-desktop \
    noto-fonts-emoji \
    qutebrowser libpipewire02 python-adblock pdfjs qt5-wayland python-tldextract

yay -S gomuks libspotify

# mopidy plugins
sudo python3 -m pip install Mopidy-Spotify Mopidy-Subidy Mopidy-MPD

