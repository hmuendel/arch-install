#! /usr/bin/zsh
set -Eeuxo pipefail
export HOSTNAME=halem
export USER=hans

# Run this as the main user of the system
su "${USER}"

# AUR Packages
# Install yay
mkdir -p ~/downloads && cd ~/downloads
# git clone https://aur.archlinux.org/yay-bin.git
# cd yay-bin
# makepkg -si
# cd .. && rm -rf yay-bin
git clone https://github.com/Morganamilo/paru.git
cd paru
makepkg -si
cd .. && rm -rf paru
# Install AUR packages
paru -S --noconfirm
  discord_arch_electron  \
  fuzzel \
  libspotify  \
  nerd-fonts-noto \
  nvim-packer-git  \
  system76-firmware \
  system76-firmware-daemon \
  wob  


#setup gpg and ssh
curl https://hmuendel-gpg-key.storage.googleapis.com/key.asc | gpg --import
cat > "${HOME}/.gnupg/gpg-agent.conf" << EOF
pinentry-program /usr/bin/pinentry-qt
keep-display
display :0.0
enable-ssh-support
write-env-file ~/.gnupg/gpg-agent-info
default-cache-ttl 300
max-cache-ttl 900
scdaemon-program /usr/lib/gnupg2/scdaemon
sh
debug-level none
homedir ~/.gnupg
EOF

gpgconf --kill gpg-agent
sleep 3

gpg --card-status
gpg -k
gpg -K
ssh-add -L



# Set shell to zsh
chsh -s /bin/zsh
# Create ~/volumes directories
mkdir -p /home/hans/volumes/{usb1,usb2,backups}
mkdir -p ~/.config

mkdir -p src
cd src
git clone git@github.com:hmuendel/dotfiles.git
# Clone all config + data repos

# link config
cd dotfiles
./link.sh

cd 
# set up .npm-global correctly
# https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'

npm i -g typescript-language-server vscode-langservers-extracted

## docker
sudo usermod -aG docker hans

# install udev rules for openocd
sudo cp /usr/share/openocd/contrib/60-openocd.rules /etc/udev/rules.d/

## rust
rustup default stable

## rust embedded
# to run `cargo size`
cargo install cargo-binutils
rustup component add llvm-tools-preview
# to run `cargo flash`
# cargo install cargo-flash

# install udev rules for probe-rs
sudo curl -o /etc/udev/rules.d/99-probe-rs.rules https://probe.rs/files/99-probe-rs.rules

# reload installed udev rules
sudo udevadm control --reload

