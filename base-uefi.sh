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

# Pretty much default
pacman -S grub efibootmgr iwd base-devel linux-headers

# Drivers
pacman -S bluez bluez-utils cups hplip alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack acpi acpi_call sof-firmware acpid mesa intel-media-driver

# Tools
pacman -S dosfstools xdg-utils openssh tlp openbsd-netcat nss-mdns inetutils dnsutils man-db kitty ripgrep zsh python python-pip borg python-llfuse brightnessctl playerctl pamixer neofetch zip unzip exa pass pass-otp zbar gnupg fzy sd starship noto-fonts-emoji ncmpcpp mpc

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable systemd-networkd
systemctl enable systemd-resolved
systemctl enable iwd
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable tlp
systemctl enable fstrim.timer
systemctl enable acpid

useradd -m chris
passwd chris
usermod -aG storage audio chris

echo "chris ALL=(ALL) ALL" >> /etc/sudoers.d/chris

# install yay
cd /tmp && git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin && makepkg -si
cd /tmp && rm -rf yay-bin

yay -S btop nvim-packer-git

## Linking up resolv.conf (to point to systemd-resolved)
rm /etc/resolv.conf
ln -s /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"

