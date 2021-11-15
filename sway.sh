#!/bin/bash

## install sway and wayland tools
sudo pacman -S sddm xdg-utils sway swayidle waybar wl-clipboard grim swappy slurp qt5ct xdg-desktop-portal xdg-desktop-portal-wlr wayland wayland-protocols xorg-xwayland swaylock libnotify gammastep dunst

yay -S wob fuzzel

# link config
for config in swappy sway waybar dunst
do
    rm -rf ~/.config/$config
    ln -s ~/dotfiles/.config/$config ~/.config/$config
done

# enable ssdm display manager
sudo systemctl enable sddm

# enable wayland/sway environment variables
sudo cp ~/dotfiles/.local/bin/sway /usr/share/bin/
sudo sed -i 's/^Exec=.*$/Exec=\/usr\/share\/bin\/sway/' /usr/share/wayland-sessions/sway.desktop

printf "\e[1;32mDone! If you're looking for a nice sddm theme, look here:\e[0m"
echo "https://framagit.org/MarianArlt/sddm-sugar-candy and https://wiki.archlinux.org/title/SDDM#Customizing_a_theme"
