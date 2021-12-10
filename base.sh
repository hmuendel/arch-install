#!/bin/bash

echo "chmanie" >> /etc/hostname
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
sed -i '177s/.//' /etc/locale.gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
locale-gen
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 chmanie.local chmanie" >> /etc/hosts
passwd

# drivers
pacman -S iwd linux-firmware bluez bluez-utils cups hplip alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack acpi acpi_call sof-firmware acpid mesa intel-media-driver vulkan-intel intel-gpu-tools

# tools
pacman -S \
    base-devel linux-headers \
    dosfstools udisks2 snapper \
    openbsd-netcat nss-mdns inetutils dnsutils wget \
    meson cmake clang \
    man-db zip unzip moreutils \
    cronie power-profiles-daemon

# enable systemd services
systemctl enable systemd-networkd
systemctl enable systemd-resolved
systemctl enable iwd
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable power-profiles-daemon
systemctl enable cronie
# enable if you want to use weekly trims
# systemctl enable fstrim.timer
systemctl enable acpid

# create user
useradd -m chris
passwd chris
groupadd plugdev
usermod -aG audio,plugdev,realtime,storage,tty,uucp,wheel chris

echo "chris ALL=(ALL) ALL" >> /etc/sudoers.d/chris

# network configuration
cat << EOF > /etc/systemd/network/20-ethernet.network
[Match]
Name=enp*

[Network]
DHCP=true
EOF

cat << EOF >> /etc/systemd/network/25-wireless.network
[Match]
Name=wlan0

[Network]
DHCP=true
EOF

# snapper btrfs snapshot config (see https://wiki.archlinux.org/title/Snapper#Configuration_of_snapper_and_mount_point)
umount /.snapshots
rm -r /.snapshots
snapper -c root create-config /
btrfs subvolume delete /.snapshots
mkdir /.snapshots
mount -a
chmod 750 /.snapshots

# move things to main user
mv /root/arch-install /home/chris/ && chown -R chris:chris /home/chris/arch-install
rm -rf /home/chris/.ssh && mv /root/.ssh /home/chris/ && chown -R chris:chris /home/chris/.ssh

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"

