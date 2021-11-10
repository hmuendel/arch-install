#!/bin/bash

## tools
sudo pacman -S timew

## web-dev
sudo pacman -S nodejs npm chromium

# set up .npm-global correctly
# https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'

npm i -g typescript-language-server vscode-langservers-extracted

## docker
sudo pacman -S docker docker-compose
sudo usermod -aG docker chris

## arduino/embedded
sudo pacman -S arduino-cli arm-none-eabi-gdb openocd arm-none-eabi-binutils
yay -S tio
# for openocd
sudo cp /usr/share/openocd/contrib/60-openocd.rules /etc/udev/rules.d/
sudo udevadm control --reload

## rust
sudo pacman -S rustup rust-analyzer
rustup default stable

## rust embedded
# to run `cargo size`
cargo install cargo-binutils
rustup component add llvm-tools-preview
# to run `cargo flash`
cargo install cargo-flash
echo 'done. to make cargo-flash work properly, install the udev rules: https://probe.rs/docs/getting-started/probe-setup/#udev-rules'
echo '---'
echo 'to compile for your target install the compile toolchain: https://docs.rust-embedded.org/book/intro/install.html'
