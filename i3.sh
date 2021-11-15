#!/bin/bash

# install xorg and i3 + tools
sudo pacman -S sddm xdg-utils i3-gaps rofi i3lock xss-lock xclip flameshot nitrogen dunst libnotify

yay -S polybar picom-jonaburg-git

for config in i3 nitrogen picom polybar rofi dunst
do
    rm -rf ~/.config/$config
    ln -s ~/dotfiles/.config/$config ~/.config/$config
done

# enable ssdm display manager
sudo systemctl enable sddm

printf "\e[1;32mDone! If you're looking for a nice sddm theme, look here:\e[0m"
echo "https://framagit.org/MarianArlt/sddm-sugar-candy and https://wiki.archlinux.org/title/SDDM#Customizing_a_theme"
