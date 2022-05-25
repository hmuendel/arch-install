# Arch Install LUKS, BTRFS, systemd-boot on a sytem76 lemur pro

completely based on https://git.sr.ht/~chmanie/arch-install

which is loosely based on 
https://www.nerdstuff.org/posts/2020/2020-004_arch_linux_luks_btrfs_systemd-boot/ 
and https://wiki.archlinux.org/title/User:M0p/LUKS_Root_on_Btrfs

## Start

Boot into the arch install iso, connect to wifi

```
iwctl
[iwd] station wlan0 scan
[iwd] station wlan0 connect <SSID>
```
Execute the installer script

```
export CRYPT_PW=<encryption password>
curl https://raw.githubusercontent.com/hmuendel/arch-install/master/install.zsh | zsh | tee install.log
```
After this is finished, reboot the machine and login as your main user. 
Excute the script in your home directory to finish setup.

```
./user-config.zsh
```

## Pacstrap Installed Packages:
### [linux](https://archlinux.org/packages/core/x86_64/linux/)
The Linux kernel and modules
### [base](https://archlinux.org/packages/core/any/base/)
Minimal package set to define a basic Arch Linux installation
### [neovim](https://archlinux.org/packages/community/x86_64/neovim/)
Fork of Vim aiming to improve user experience, plugins, and GUIs
### [intel-ucode](https://archlinux.org/packages/extra/any/intel-ucode/)
Microcode update files for Intel CPUs
### [btrfs-progs](https://archlinux.org/packages/core/x86_64/btrfs-progs/)
Btrfs filesystem utilities
### [efibootmgr](https://archlinux.org/packages/core/x86_64/efibootmgr/)
Linux user-space application to modify the EFI Boot Manager
### [zsh](https://archlinux.org/packages/extra/x86_64/zsh/)
A very advanced and programmable command interpreter (shell) for UNIX


## Later Installed Packages
### [acpi](https://archlinux.org/packages/community/x86_64/acpi/)
Client for battery, power, and thermal readings
### [acpi_call](https://archlinux.org/packages/community/x86_64/acpi_call/)
A linux kernel module that enables calls to ACPI methods through /proc/acpi/call
### [acpid](https://archlinux.org/packages/community/x86_64/acpid/)
A daemon for delivering ACPI power management events with netlink support
### [alacritty](https://archlinux.org/packages/community/x86_64/alacritty/)
### [alsa-utils](https://archlinux.org/packages/extra/x86_64/alsa-utils/)
Advanced Linux Sound Architecture - Utilities
### [base-devel](https://archlinux.org/groups/x86_64/base-devel/)
### [bat](https://archlinux.org/packages/community/x86_64/bat/)
Cat clone with syntax highlighting and git integration
### [bluez](https://archlinux.org/packages/extra/x86_64/bluez/)
Daemons for the bluetooth protocol stack
### [bluez-utils](https://archlinux.org/packages/extra/x86_64/bluez-utils/)
Development and debugging utilities for the bluetooth protocol stack
### [brightnessctl](https://archlinux.org/packages/community/x86_64/brightnessctl/)
### [btop](https://archlinux.org/packages/community/x86_64/btop/)
A monitor of system resources, bpytop ported to C++
Lightweight brightness control tool
### [clang](https://archlinux.org/packages/extra/x86_64/clang/)
C language family frontend for LLVM
### [cmake](https://archlinux.org/packages/extra/x86_64/cmake/)
A cross-platform open-source make system
### [cups](https://archlinux.org/packages/extra/x86_64/cups/)
The CUPS Printing System - daemon package
### [docker](https://archlinux.org/packages/community/x86_64/docker/)
Pack, ship and run any application as a lightweight container
### [docker-compose](https://archlinux.org/packages/community/x86_64/docker-compose/)
Fast, isolated development environments using Docker
### [dosfstools](https://archlinux.org/packages/core/x86_64/dosfstools/)
DOS filesystem utilities
### [dust](https://archlinux.org/packages/community/x86_64/dust/)
A more intuitive version of du in rust
### [fd](https://archlinux.org/packages/community/x86_64/fd/)
Simple, fast and user-friendly alternative to find
### [git](https://archlinux.org/packages/extra/x86_64/git/)
the fast distributed version control system
### [git-delta](https://archlinux.org/packages/community/x86_64/git-delta/)
Syntax-highlighting pager for git and diff output
### [gnupg](https://archlinux.org/packages/core/x86_64/gnupg/)
Complete and free implementation of the OpenPGP standard
### [gopass](https://archlinux.org/packages/community/x86_64/gopass/)
The slightly more awesome standard unix password manager for teams.
### [grim](https://archlinux.org/packages/community/x86_64/grim/)
Screenshot utility for Wayland
### [hplip](https://archlinux.org/packages/extra/x86_64/hplip/)
Drivers for HP DeskJet, OfficeJet, Photosmart, Business Inkjet and some LaserJet
[i3status-rust](https://archlinux.org/packages/community/x86_64/i3status-rust/)
Resourcefriendly and feature-rich replacement for i3status, written in pure Rust
[imv](https://archlinux.org/packages/community/x86_64/imv/)
Image viewer for Wayland and X11
### [inetutils](https://archlinux.org/packages/core/x86_64/inetutils/)
A collection of common network programs
### [intel-gpu-tools](https://archlinux.org/packages/community/x86_64/intel-gpu-tools/)
Tools for development and testing of the Intel DRM driver
### [intel-media-driver](https://archlinux.org/packages/community/x86_64/intel-media-driver/)
Intel Media Driver for VAAPI — Broadwell+ iGPUs
### [iwd](https://archlinux.org/packages/community/x86_64/iwd/)
Internet Wireless Daemon
### [jq](https://archlinux.org/packages/community/x86_64/jq/)
Command-line JSON processor
### [ldns](https://archlinux.org/packages/core/x86_64/ldns/)
Fast DNS library supporting recent RFCs
### [libnotify](https://archlinux.org/packages/extra/x86_64/libnotify/) 
Library for sending desktop notifications
### [libpipewire02](https://archlinux.org/packages/extra/x86_64/libpipewire02/)
Low-latency audio/video router and processor - legacy client library
### [linux-firmware](https://archlinux.org/packages/core/any/linux-firmware/)
Firmware files for Linux
### [linux-headers](https://archlinux.org/packages/core/x86_64/linux-headers/)
Headers and scripts for building modules for the Linux kernel
### [lsd](https://archlinux.org/packages/community/x86_64/lsd/)
Modern ls with a lot of pretty colors and awesome icons
### [man-db](https://archlinux.org/packages/core/x86_64/man-db/)
A utility for reading man pages
### [mesa](https://archlinux.org/packages/extra/x86_64/mesa/)
An open-source implementation of the OpenGL specification
### [meson](https://archlinux.org/packages/extra/any/meson/)
High productivity build system
### [moreutils](https://archlinux.org/packages/community/x86_64/moreutils/)
A growing collection of the unix tools that nobody thought to write thirty years ago
### [mpv](https://archlinux.org/packages/community/x86_64/mpv/)
a free, open source, and cross-platform media player
### [neomutt](https://archlinux.org/packages/community/x86_64/neomutt/)
A version of mutt with added features
### [nodejs](https://archlinux.org/packages/community/x86_64/nodejs/)
Evented I/O for V8 javascript
### [noto-fonts-emoji](https://archlinux.org/packages/extra/any/noto-fonts-emoji/)
Google Noto emoji fonts
### [npm](https://archlinux.org/packages/community/any/npm/)
A package manager for javascript
### [nss-mdns](https://archlinux.org/packages/extra/x86_64/nss-mdns/)
glibc plugin providing host name resolution via mDNS
### [openbsd-netcat](https://archlinux.org/packages/community/x86_64/openbsd-netcat/)
TCP/IP swiss army knife. OpenBSD variant.
### [openssh](https://archlinux.org/packages/core/x86_64/openssh/)
Premier connectivity tool for remote login with the SSH protocol
### [pamixer](https://archlinux.org/packages/community/x86_64/pamixer/)
Pulseaudio command-line mixer like amixer
### [pandoc](https://archlinux.org/packages/community/x86_64/pandoc/)
Conversion between markup formats
### [pass](https://archlinux.org/packages/community/any/pass/)
Stores, retrieves, generates, and synchronizes passwords securely
### [pavucontrol](https://archlinux.org/packages/extra/x86_64/pavucontrol/)
PulseAudio Volume Control
### [pinentry](https://archlinux.org/packages/core/x86_64/pinentry/)
Collection of simple PIN or passphrase entry dialogs which utilize the Assuan protoco
### [pipewire](https://archlinux.org/packages/extra/x86_64/pipewire/)
Low-latency audio/video router and processor
### [pipewire-alsa](https://archlinux.org/packages/extra/x86_64/pipewire-alsa/)
Low-latency audio/video router and processor - ALSA configuration
### [pipewire-jack](https://archlinux.org/packages/extra/x86_64/pipewire-jack/)
Low-latency audio/video router and processor - JACK support
### [pipewire-pulse](https://archlinux.org/packages/extra/x86_64/pipewire-pulse/)
Low-latency audio/video router and processor - PulseAudio replacement
### [playerctl](https://archlinux.org/packages/community/x86_64/playerctl/)
mpris media player controller and lib for spotify, vlc, audacious, bmp, xmms2, and others
### [power-profiles-daemon](https://archlinux.org/packages/extra/x86_64/power-profiles-daemon/)
Makes power profiles handling available over D-Bus
### [procs](https://archlinux.org/packages/community/x86_64/procs/)
A modern replacement for ps written in Rust
### [python](https://archlinux.org/packages/core/x86_64/python/)
Next generation of the python high-level scripting language
### [python-adblock](https://archlinux.org/packages/community/x86_64/python-adblock/)
Brave's adblock library in Python
### [python-pip](https://archlinux.org/packages/extra/any/python-pip/) 
The PyPA recommended tool for installing Python packages
### [qt5ct](https://archlinux.org/packages/community/x86_64/qt5ct/)
Qt5 Configuration Utility
### [qt5-wayland](https://archlinux.org/packages/extra/x86_64/qt5-wayland/)
Provides APIs for Wayland
[urlscan](https://archlinux.org/packages/community/any/urlscan/)
Mutt and terminal url selector
### [ripgrep](https://archlinux.org/packages/community/x86_64/ripgrep/)
A search tool that combines the usability of ag with the raw speed of grep
### [rustup](https://archlinux.org/packages/community/x86_64/rustup/)
The Rust toolchain installer
### [rust-analyzer](https://archlinux.org/packages/community/x86_64/rust-analyzer/)
Rust compiler front-end for IDEs
### [sd](https://archlinux.org/packages/community/x86_64/sd/)
Intuitive find & replace
### [signal-desktop](https://archlinux.org/packages/community/x86_64/signal-desktop/)
Signal Private Messenger for Linux
### [skim](https://archlinux.org/packages/community/x86_64/skim/)
Fuzzy Finder in rust!
### [slurp](https://archlinux.org/packages/community/x86_64/slurp/)
Select a region in a Wayland compositor
### [snapper](https://archlinux.org/packages/community/x86_64/snapper/)
A tool for managing BTRFS and LVM snapshots. It can create, diff and restore snapshots and provides timelined auto-snapping.
### [starship](https://archlinux.org/packages/community/x86_64/starship/)
The cross-shell prompt for astronauts
### [swappy](https://archlinux.org/packages/community/x86_64/swappy/)
A Wayland native snapshot editing tool
### [sway](https://archlinux.org/packages/community/x86_64/sway/)
Tiling Wayland compositor and replacement for the i3 window manager
### [swayidle](https://archlinux.org/packages/community/x86_64/swayidle/)
Idle management daemon for Wayland
### [swaylock](https://archlinux.org/packages/community/x86_64/swaylock/)
Screen locker for Wayland
### [task](https://archlinux.org/packages/community/x86_64/task/)
A command-line todo list manager
### [termdown](https://archlinux.org/packages/community/any/termdown/)
Countdown timer and stopwatch in your terminal
### [texlive-core](https://archlinux.org/packages/extra/any/texlive-core/)
TeX Live core distribution
### [timew](https://archlinux.org/packages/community/x86_64/timew/)
Timewarrior, A command line time tracking application
### [torbrowser-launcher](https://archlinux.org/packages/community/any/torbrowser-launcher/)
Securely and easily download, verify, install, and launch Tor Browser in Linux
### [udisks2](https://archlinux.org/packages/extra/x86_64/udisks2/)
Disk Management Service, version 2
### [unzip](https://archlinux.org/packages/extra/x86_64/unzip/)
For extracting and viewing files in .zip archives
### [vulkan-itel](https://archlinux.org/packages/extra/x86_64/vulkan-intel/)
ntel's Vulkan mesa driver
### [waybar](https://archlinux.org/packages/community/x86_64/waybar/)
Highly customizable Wayland bar for Sway and Wlroots based compositors
### [wayland](https://archlinux.org/packages/extra/x86_64/wayland/)
A computer display server protocol
### [wayland-protocols](https://archlinux.org/packages/extra/any/wayland-protocols/)
Specifications of extended Wayland protocols
### [wireguard-tools](https://archlinux.org/packages/extra/x86_64/wireguard-tools/)
next generation secure network tunnel - tools for configuration
### [wl-clipboard](https://archlinux.org/packages/community/x86_64/wl-clipboard/)
Command-line copy/paste utilities for Wayland
### [xdg-desktop-portal-wlr](https://archlinux.org/packages/community/x86_64/xdg-desktop-portal-wlr/)
xdg-desktop-portal backend for wlroots
### [xdg-utils](https://archlinux.org/packages/extra/any/xdg-utils/)
Command line tools that assist applications with a variety of desktop integration tasks
### [xorg-xwayland](https://archlinux.org/packages/extra/any/xorg-xwayland/)
run X clients under wayland
### [yq](https://archlinux.org/packages/community/any/yq/)
Command-line YAML, XML, TOML processor - jq wrapper for YAML/XML/TOML documents
### [yt-dlp](https://archlinux.org/packages/community/any/yt-dlp/)
A youtube-dl fork with additional features and fixes
### [zathura](https://archlinux.org/packages/community/x86_64/zathura/)
Minimalistic document viewer
### [zathura-pdf-mupdf](https://archlinux.org/packages/community/x86_64/zathura-pdf-mupdf/)
PDF support for Zathura (MuPDF backend) (Supports PDF, ePub, and OpenXPS)
### [zbar](https://archlinux.org/packages/extra/x86_64/zbar/)
Application and library for reading bar codes from various sources
### [zip](https://archlinux.org/packages/extra/x86_64/zip/)
Compressor/archiver for creating and modifying zipfiles



## AUR
### [discord_arch_electron](https://aur.archlinux.org/packages/discord_arch_electron/)
### [fuzzel](https://aur.archlinux.org/packages/fuzzel/)
Application launcher for wlroots based Wayland compositors
### [libspotify](https://aur.archlinux.org/packages/libspotify/)
C API package allowing third-party developers to write applications that utilize the Spotify music streaming service
### [nerd-fonts-noto](https://aur.archlinux.org/packages/nerd-fonts-noto/)
Patched font Noto from the nerd-fonts library
### [nvim-packer-git](https://aur.archlinux.org/packages/nvim-packer-git/)
A use-package inspired plugin manager for Neovim.
### [system76-firmware](https://aur.archlinux.org/packages/system76-firmware/)
System76 CLI tool for installing firmware updates
### [system76-firmware-daemon](https://aur.archlinux.org/packages/system76-firmware-daemon/)
System76 systemd service that exposes a DBUS API for handling firmware updates
### [wob](https://aur.archlinux.org/packages/wob/)
A lightweight overlay volume/backlight/progress/anything bar for Wayland


## Taking snapshots with snapper

### Create manual root filesystem snapshot

```
snapper -c root create --description 'Foo'
```

### Restoring snapshots

To restore a previous snapshot see 
https://wiki.archlinux.org/title/Snapper#Restoring_/_to_its_previous_snapshot.

