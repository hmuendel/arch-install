#! /usr/bin/zsh
set -Eeuxo pipefail
export HOSTNAME=halem
export USER=hans

echo "${HOSTNAME}" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 ${HOSTNAME}.local ${HOSTNAME}" >> /etc/hosts
passwd

# enable systemd services
systemctl enable systemd-networkd
systemctl enable systemd-resolved
systemctl enable iwd
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable power-profiles-daemon
# enable if you want to use weekly trims
systemctl enable fstrim.timer
systemctl enable acpid


# pacman configuration
sed -i 's/\[options\]/[options]\nColor\nILoveCandy\nVerbosePkgLists/' /etc/pacman.conf

# # network configuration
# cat << EOF > /etc/systemd/network/20-ethernet.network
# [Match]
# Name=enp*

# [Network]
# DHCP=true
# EOF

cat << EOF > /etc/systemd/network/25-wireless.network
[Match]
Name=wlan0

[Network]
DHCP=true
EOF

# snapper btrfs snapshot config (see https://wiki.archlinux.org/title/Snapper#Configuration_of_snapper_and_mount_point)
#
umount /.snapshots || true
rm -r /.snapshots || true
snapper --no-dbus -c root create-config /
btrfs subvolume delete /.snapshots
mkdir /.snapshots
mount -a
chmod 750 /.snapshots

# create user
useradd -m "${USER}"
passwd "${USER}"
groupadd plugdev
usermod -aG audio,plugdev,storage,tty,uucp,wheel "${USER}"

echo "${USER} ALL=(ALL) ALL" >> /etc/sudoers.d/"${USER}"
# move things to main user
rm -rf "/home/${USER}/.ssh" && mv "/root/.ssh /home/${USER}/" && chown -R "${USER}:${USER}" "/home/${USER}/.ssh"


# Link resolv.conf (needed for importing keys with gpg)
rm /etc/resolv.conf
ln -s /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf



