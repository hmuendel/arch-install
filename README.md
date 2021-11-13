# Arch Install LUKS, BTRFS, systemd-boot

(loosely based on https://www.nerdstuff.org/posts/2020/2020-004_arch_linux_luks_btrfs_systemd-boot/)

In this repository you will find packages-scripts for the base install of Arch Linux and the Gnome, i3 and sway environments.
Modify the packages to your liking and then run with ./scriptname.


## Start

Boot into the arch install iso, connect to wifi/ethernet and refresh the servers with `pacman -Syy`

## Partitioning

For the rest of this post, we assume that we install Arch Linux on `/dev/nvme0n1`. Adjust the steps for your setup if necessary.

```
# gdisk /dev/nvme0n1
```

Create new partition table:

```
Command (? for help): o
```

Create an EFI partition (choose size 550M and hex code `EF00`):

```
Command (? for help): n
```

Create a root partition (adopt the default values):

```
Command (? for help): n
```

Write the new partitions to disk:

```
Command (? for help): w
```

## Encryption

Create an encrypted container for the root file system (you need to define a passphrase):

```
# cryptsetup luksFormat /dev/nvme0n1p2
```

Open the container ("`cryptoroot`" is just a placeholder, you can use a name of your choice, but remember to adopt the subsequent steps of the guide accordingly):

```
# cryptsetup open /dev/nvme0n1p2 cryptoroot
```

## File System Creation

Format the EFI partition with FAT32 and give it the label `EFI` - you can choose any other label name:

```
# mkfs.vfat -F32 -n EFI /dev/nvme0n1p1
```

Format the root partition with Btrfs and give it the label `ROOT` - you can choose any other label name. If you didn't open the LUKS container under the name "`cryptoroot`" you must adjust the command accordingly:

```
# mkfs.btrfs -L ROOT /dev/mapper/cryptoroot

```

## Create and Mount Subvolumes

Create [subvolumes](https://wiki.archlinux.org/index.php/Btrfs#Subvolumes) for root, home, the package cache, [snapshots](https://wiki.archlinux.org/index.php/Btrfs#Snapshots) and the entire Btrfs file system:

```
# mount /dev/mapper/cryptoroot /mnt
# btrfs sub create /mnt/@
# btrfs sub create /mnt/@home
# btrfs sub create /mnt/@pkg
# btrfs sub create /mnt/@snapshots
# btrfs sub create /mnt/@docker #if you want to use docker
# umount /mnt

```

Mount the subvolumes:

```
# mount -o noatime,nodiratime,compress=zstd,space_cache,discard=async,autodefrag,subvol=@ /dev/mapper/cryptoroot /mnt
# mkdir -p /mnt/{boot,home,var/cache/pacman/pkg,/var/lib/docker/btrfs,.snapshots,btrfs}
# mount -o noatime,nodiratime,compress=zstd,space_cache,discard=async,autodefrag,subvol=@home /dev/mapper/cryptoroot /mnt/home
# mount -o noatime,nodiratime,compress=zstd,space_cache,discard=async,autodefrag,subvol=@pkg /dev/mapper/cryptoroot /mnt/var/cache/pacman/pkg
# mount -o noatime,nodiratime,compress=zstd,space_cache,discard=async,autodefrag,subvol=@snapshots /dev/mapper/cryptoroot /mnt/.snapshots
# mount -o noatime,nodiratime,compress=zstd,space_cache,discard=async,autodefrag,subvol=@docker /dev/mapper/cryptoroot /mnt/var/lib/docker/btrfs
# mount -o noatime,nodiratime,compress=zstd,space_cache,discard=async,autodefrag,subvolid=5 /dev/mapper/cryptoroot /mnt/btrfs
```

Mount the EFI partition

```
# mkdir /mnt/boot
# mount /dev/nvme0n1p1 /mnt/boot
```

## Base System and `/etc/fstab`

Install Arch Linux (adjust this list to your needs):

```
# pacstrap /mnt linux base neovim intel-ucode btrfs-progs git openssh
```

Generate `/etc/fstab`:

```
# genfstab -U /mnt >> /mnt/etc/fstab
```

`chroot` into the new system:

```
# arch-chroot /mnt/
```

### Initramfs

Configure the creation of [initramfs](https://wiki.archlinux.org/index.php/Arch_boot_process#initramfs) by editing `/etc/mkinitcpio.conf`. Change the line `HOOKS=...` to:

```
HOOKS="base keyboard udev autodetect modconf block encrypt btrfs filesystems fsck"
```

Recreate initramfs:

```
# mkinitcpio -p linux
```

### Boot Manager

Install [systemd-boot](https://wiki.archlinux.org/index.php/Systemd-boot):

```
# bootctl --path=/boot install
```

The UUID of the root partition can be determined via `blkid`. Create file `/boot/loader/entries/arch.conf` containing the uuid like so: 

```
# blkid -s UUID -o value /dev/nvme0n1p2 > /boot/loader/entries/arch.conf
```

And fill it with:

```
title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options cryptdevice=UUID=<UUID-OF-ROOT-PARTITION>:cryptoroot:allow-discards root=/dev/mapper/cryptoroot rootflags=subvol=@ rd.luks.options=discard rw
```

Edit file `/boot/loader/loader.conf` and fill it with:

```
default  arch.conf
timeout  4
console-mode max
editor   no
```

## System Configuration

Clone the install repository:

```
# cd ~ && git clone git@git.sr.ht:~chmanie/arch-install
# cd arch-install
# ./base.sh
```

### Final Steps

Exit `chroot`, unmount partitions and reboot:

```
# exit
# umount -R /mnt
# reboot
```

After the reboot, the `arch-install` files will be in your home directory. Continue with `post-install.sh` (important!), the rest can be run in any order.

Have fun with your system!

## References

[1] [Arch My Way 1 | Grundsystem installieren](https://www.youtube.com/watch?v=oT7gs2CmsnQ) (German)

[2] [Arch Linux - UEFI, systemd-boot, LUKS, and btrfs](https://austinmorlan.com/posts/arch_linux_install/)

[3] [Arch Linux Wiki: systemd-boot](https://wiki.archlinux.org/index.php/systemd-boot)
