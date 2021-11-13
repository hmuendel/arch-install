#!/bin/bash

ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "chmanie" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 chmanie.local chmanie" >> /etc/hosts
passwd

# boot manager
pacman -S grub grub-btrfs efibootmgr

# drivers
pacman -S iwd linux-firmware bluez bluez-utils cups hplip alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack acpi acpi_call sof-firmware acpid mesa intel-media-driver vulkan-intel

# tools
pacman -S \
    base-devel linux-headers \
    dosfstools xdg-utils \
    openssh openbsd-netcat nss-mdns inetutils dnsutils \
    ripgrep zsh fzy sd starship exa \
    cronie power-profiles-daemon \
    python python-pip \
    meson cmake \
    man-db zip unzip moreutils \
    borg python-llfuse \
    brightnessctl playerctl pamixer neofetch \
    gnupg pass pass-otp zbar \
    pandoc texlive-core

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable systemd-networkd
systemctl enable systemd-resolved
systemctl enable iwd
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable power-profiles-daemon
systemctl enable cronie
# Enable if you want to use weekly trims
# systemctl enable fstrim.timer
systemctl enable acpid

useradd -m chris
passwd chris
usermod -aG audio,storage,tty,uucp,wheel chris

echo "chris ALL=(ALL) ALL" >> /etc/sudoers.d/chris

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"

