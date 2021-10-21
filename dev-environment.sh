#!/bin/bash

## tools
sudo pacman -S timew

## web-dev
sudo pacman -S nodejs npm chromium
# MAKE SURE TO have set up .npm-global correctly before:
# https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally
npm i -g typescript-language-server eslint_d prettier_d_slim prettier vscode-langservers-extracted

## arduino/embedded
sudo pacman -S arduino-cli arm-none-eabi-gdb openocd
yay -S tio
# for openocd
sudo cp /usr/share/openocd/contrib/60-openocd.rules /etc/udev/rules.d/
sudo udevadm control --reload

## rust
mkdir -p ~/downloads && cd downloads
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rust.sh
./rust.sh
rm rust.sh

## rust-analyzer
mkdir -p ~/downloads && cd downloads
git clone https://github.com/rust-analyzer/rust-analyzer.git && cd rust-analyzer
cargo xtask install --server
cd ~/downloads && rm -rf rust-analyzer

