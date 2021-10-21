#!/bin/bash

# Run this as the main user of the system

# Install yay
mkdir -p ~/downloads && cd ~/downloads
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
cd .. && rm -rf yay-bin

# Link resolv.conf (needed for importing keys with gpg)
sudo rm /etc/resolv.conf
sudo ln -s /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

# Install AUR packages
yay -S nvim-packer-git btop
