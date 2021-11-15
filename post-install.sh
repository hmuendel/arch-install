#!/bin/bash

# Run this as the main user of the system

# Install yay
mkdir -p ~/downloads && cd ~/downloads
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
cd .. && rm -rf yay-bin

# Install some basic tools
sudo pacman -S \
    ripgrep zsh fzy sd fd starship exa z \
    python python-pip \
    borg python-llfuse nextcloud-client \
    brightnessctl playerctl pamixer neofetch \
    gnupg pass pass-otp zbar \
    pandoc texlive-core

# Install AUR packages
yay -S nvim-packer-git btop

# Link resolv.conf (needed for importing keys with gpg)
sudo rm /etc/resolv.conf
sudo ln -s /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

# Set shell to zsh
chsh -s /bin/zsh
echo 'ZDOTDIR=$HOME/.config/zsh' > ~/.zshenv

# Create ~/volumes directories
mkdir -p /home/chris/volumes/{usb1,usb2,backups}

# Clone all config + data repos
git clone --recursive git@git.sr.ht:~chmanie/dotfiles ~/dotfiles
git clone git@git.sr.ht:~chmanie/fonts ~/.fonts
git clone git@git.sr.ht:~chmanie/pass ~/.password-store
git clone git@git.sr.ht:~chmanie/org ~/org

# link config
for config in nvim pipewire zsh starship.toml
do
    rm -rf ~/.config/$config
    ln -s ~/dotfiles/.config/$config ~/.config/$config
done

rm -rf ~/.local/share/applications
ln -s ~/dotfiles/.local/share/applications ~/.local/share/applications

ln -s ~/dotfiles/.xkb ~/.xkb
rm -f ~/.gitconfig && ln -s ~/dotfiles/.gitconfig ~/.gitconfig

# copy background pictures
cp -R pictures ~/

printf "\e[1;32mIMPORTANT! This is the time where you recover your .gnupg and .private directories from a backup!\e[0m"
