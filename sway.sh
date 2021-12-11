#!/bin/bash

## install sway and wayland tools
sudo pacman -S xdg-utils sway swayidle waybar wl-clipboard grim swappy slurp qt5ct xdg-desktop-portal xdg-desktop-portal-wlr wayland wayland-protocols xorg-xwayland swaylock libnotify gammastep dunst

yay -S wob fuzzel

# link config
for config in swappy sway waybar dunst swaylock
do
    rm -rf ~/.config/$config
    ln -s ~/dotfiles/.config/$config ~/.config/$config
done

# enable wayland/sway environment variables
sudo mkdir /usr/share/bin
sudo cp ~/dotfiles/.local/bin/sway /usr/share/bin/
sudo sed -i 's/^Exec=.*$/Exec=\/usr\/share\/bin\/sway/' /usr/share/wayland-sessions/sway.desktop

printf "\e[1;32mDone!\e[0m"
