#!/bin/bash

# install xorg and i3 + tools
sudo pacman -S xdg-utils i3-gaps rofi i3lock xss-lock xclip flameshot nitrogen dunst libnotify

yay -S polybar picom-jonaburg-git

for config in i3 nitrogen picom polybar rofi dunst
do
    rm -rf ~/.config/$config
    ln -s ~/dotfiles/.config/$config ~/.config/$config
done

printf "\e[1;32mDone!\e[0m"
