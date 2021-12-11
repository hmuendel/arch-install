#!/bin/bash

## install sddm display manager
sudo pacman -S sddm

# enable ssdm
sudo systemctl enable sddm

# install sddm theme
cd /tmp && wget https://framagit.org/MarianArlt/sddm-sugar-candy/-/archive/master/sddm-sugar-candy-master.tar.gz
sudo tar -xzvf sddm-sugar-candy-master.tar.gz -C /usr/share/sddm/themes
sudo mv /usr/share/sddm/themes/sddm-sugar-candy-master /usr/share/sddm/themes/sugar-candy
sudo cp /usr/lib/sddm/sddm.conf.d/default.conf /etc/sddm.conf
sudo sed -i 's/Current=/Current=sugar-candy/' /etc/sddm.conf
sudo cp /home/chris/pictures/168875-japan-tokyo-at-night-wallpaper-top-free-japan-tokyo-at-night.jpg /usr/share/sddm/themes/sugar-candy/Backgrounds/
sudo sed -i 's/Background=.*/Background="Backgrounds\/168875-japan-tokyo-at-night-wallpaper-top-free-japan-tokyo-at-night.jpg"/' /usr/share/sddm/themes/sugar-candy/theme.conf
sudo sed -i 's/ForceHideCompletePassword=.*/ForceHideCompletePassword="true"/' /usr/share/sddm/themes/sugar-candy/theme.conf

printf "\e[1;32mDone!\e[0m"
