#!/bin/bash

## install sway and wayland tools
sudo pacman -S sddm sway swayidle waybar wofi wl-clipboard grim swappy slurp qt5ct xdg-desktop-portal xdg-desktop-portal-wlr wayland wayland-protocols xorg-xwayland swaylock mako

yay -S wob wlsunset

# link config
for config in mako swappy sway waybar wofi
do
    rm -rf ~/.config/$config
    ln -s ~/dotfiles/.config/$config ~/.config/$config
done

# enable ssdm display manager
sudo systemctl enable sddm

# enable wayland/sway environment variables
sudo cp ~/dotfiles/.local/bin/sway /usr/share/bin/
sudo sed -i 's/^Exec=.*$/Exec=\/usr\/share\/bin\/sway/' /usr/share/wayland-sessions/sway.desktop
