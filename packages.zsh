#! /usr/bin/zsh
set -Eeuxo pipefail

ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
locale-gen

pacman -Syy
pacman -S --noconfirm \
    acpi \
    acpi_call \
    acpid \
    alacritty \
    alsa-utils \
    base-devel \
    bat \
    bluez \
    bluez-utils \
    brightnessctl \
    btop \
    clang \
    cmake \
    cups \
    docker \
    docker-compose \
    dosfstools \
    dust \
    fd \
    git \
    git-delta \
    gnupg \
    gopass \
    grim \
    hplip \
    i3status \
    imv \
    inetutils \
    intel-gpu-tools \
    intel-media-driver \
    iwd \
    jq \
    ldns \
    libnotify \
    libpipewire02 \
    linux-firmware \
    linux-headers \
    lsd \
    man-db \
    mesa \
    meson \
    moreutils \
    mpv \
    neomutt \
    nodejs \
    noto-fonts-emoji \
    npm \
    nss-mdns \
    openssh \
    pamixer \
    pandoc \
    pass \
    pass-otp \
    pavucontrol \
    pinentry \
    pipewire \
    pipewire-alsa \
    pipewire-jack \
    pipewire-pulse \
    playerctl \
    power-profiles-daemon \
    procs \
    python \
    python-adblock \
    python-pip \
    qt5-wayland \
    qt5ct \
    ripgrep \
    rust-analyzer \
    rustup \
    sd \
    signal-desktop \
    skim \
    slurp \
    snapper \
    starship \
    swappy \
    sway \
    swayidle \
    swaylock \
    task \
    termdown \
    texlive-core \
    timew \
    torbrowser-launcher \
    udisks2 \
    unzip \
    urlscan \
    vulkan-intel \
    waybar \
    wayland \
    wayland-protocols \
    wireguard-tools \
    wl-clipboard \
    xdg-desktop-portal-wlr \
    xdg-utils \
    yq \
    yt-dlp \
    zathura \
    zathura-pdf-mupdf \
    zbar \
    zip 

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

