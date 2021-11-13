#!/bin/bash

# install xorg and i3 + tools
sudo pacman -S sddm xorg i3-gaps rofi i3lock xss-lock xclip flameshot nitrogen

yay -S polybar picom-jonaburg-git

for config in i3 nitrogen picom polybar rofi
do
    rm -rf ~/.config/$config
    ln -s ~/dotfiles/.config/$config ~/.config/$config
done

# enable ssdm display manager
sudo systemctl enable sddm
