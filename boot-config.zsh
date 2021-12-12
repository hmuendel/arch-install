#! /usr/bin/zsh
set -Eeuxo pipefail
# Configure the creation of 
# [initramfs](https://wiki.archlinux.org/index.php/Arch_boot_process#initramfs) 
# by editing `/etc/mkinitcpio.conf`. Change the line `HOOKS=...` to:
#
sed -i 's/HOOKS=(.*)/HOOKS=(base keyboard udev autodetect modconf block encrypt btrfs filesystems fsck)/' /etc/mkinitcpio.conf 

mkinitcpio -p linux

bootctl --path=/boot install

# The UUID of the root partition can be determined via `blkid`. Create file 
# `/boot/loader/entries/arch.conf` containing the uuid like so: 
cat > /boot/loader/entries/arch.conf << EOF
title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options cryptdevice=UUID=$(blkid -s UUID -o value /dev/nvme0n1p2):cryptoroot:allow-discards root=/dev/mapper/cryptoroot rootflags=subvol=@/0/snapshot rd.luks.options=discard rw
EOF

cat > /boot/loader/loader.conf << EOF
default  arch.conf
timeout  4
console-mode max
editor   no
EOF
