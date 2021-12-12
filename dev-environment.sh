#!/bin/bash

## configure git
git config --global user.email "hans@muendelein.me"
git config --global user.name "hans"

## tools
sudo pacman -S timew jq yq

## web-dev
sudo pacman -S nodejs npm chromium

# set up .npm-global correctly
# https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'

npm i -g typescript-language-server vscode-langservers-extracted

## docker
sudo pacman -S docker docker-compose
sudo usermod -aG docker hans

## arduino/embedded
sudo pacman -S arduino-cli arm-none-eabi-gdb openocd arm-none-eabi-binutils
yay -S tio

# install udev rules for openocd
sudo cp /usr/share/openocd/contrib/60-openocd.rules /etc/udev/rules.d/

## rust
sudo pacman -S rustup rust-analyzer
rustup default stable

## rust embedded
# to run `cargo size`
cargo install cargo-binutils
rustup component add llvm-tools-preview
# to run `cargo flash`
cargo install cargo-flash

# install udev rules for probe-rs
sudo curl -o /etc/udev/rules.d/99-probe-rs.rules https://probe.rs/files/99-probe-rs.rules

# reload installed udev rules
sudo udevadm control --reload

# link config
for config in chromium-flags.conf
do
    rm -rf ~/.config/$config
    ln -s ~/dotfiles/.config/$config ~/.config/$config
done

printf "\e[1;32mDone. To compile for your target install the compile toolchain: https://docs.rust-embedded.org/book/intro/install.html\e[0m"
