# Arch Install LUKS, BTRFS, systemd-boot

completely based on https://git.sr.ht/~chmanie/arch-install

which is loosely based on 
https://www.nerdstuff.org/posts/2020/2020-004_arch_linux_luks_btrfs_systemd-boot/ 
and https://wiki.archlinux.org/title/User:M0p/LUKS_Root_on_Btrfs
In this repository you will find packages-scripts for the base install of Arch 
Linux and the Gnome, i3 and sway environments.
Modify the packages to your liking and then run with ./scriptname.

## Start

Boot into the arch install iso, connect to wifi/ethernet and refresh the servers 
with `pacman -Syy`

## Partitioning

For the rest of this post, we assume that we install Arch Linux on 
`/dev/nvme0n1`. Adjust the steps for your setup if necessary.

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

Create an encrypted container for the root file system (you need to define a
passphrase):

```
# cryptsetup luksFormat /dev/nvme0n1p2
```

Open the container ("`cryptoroot`" is just a placeholder, you can use a name of 
your choice, but remember to adopt the subsequent steps of the guide accordingly):

```
# cryptsetup open /dev/nvme0n1p2 cryptoroot
```

## File System Creation

Format the EFI partition with FAT32 and give it the label `EFI` - you can 
choose any other label name:

```
# mkfs.vfat -F32 -n EFI /dev/nvme0n1p1
```

Format the root partition with Btrfs and give it the label `ROOT` - you can 
choose any other label name. If you didn't open the LUKS container under the 
name "`cryptoroot`" you must adjust the command accordingly:

```
# mkfs.btrfs -L ROOT /dev/mapper/cryptoroot

```

## Create and Mount Subvolumes

Create [subvolumes](https://wiki.archlinux.org/index.php/Btrfs#Subvolumes) for 
root, home, the package cache, 
[snapshots](https://wiki.archlinux.org/index.php/Btrfs#Snapshots) and the entire 
Btrfs file system:

```
# cd /mnt

# btrfs subvolume create @
# mkdir @/0
# btrfs subvolume create @/0/snapshot

# for i in {home,root,srv,usr,usr/local,swap,var};
do btrfs subvolume create @$i;
done

# for i in {tmp,spool,log};
do btrfs subvolume create @var/$i;
done

# mkdir -p @var/lib/docker
# btrfs sub create @var/lib/docker/btrfs
# umount /mnt

```

Mount the subvolumes:

```
# cd ~
# umount /mnt
# mount -o noatime,nodiratime,compress=zstd,space_cache=v2,discard=async,autodefrag,subvol=@/0/snapshot /dev/mapper/cryptoroot /mnt

# mkdir -p /mnt/{.snapshots,home,root,srv,tmp,usr/local,swap}
# mkdir -p /mnt/var/{tmp,spool,log,lib/docker/btrfs}

# mount -o noatime,nodiratime,compress=zstd,space_cache=v2,discard=async,autodefrag,subvol=@ /dev/mapper/cryptoroot /mnt/.snapshots/ 

# for i in {home,root,srv,swap,usr/local};
do mount -o subvol=@$i,noatime,nodiratime,compress=zstd,space_cache=v2,discard=async,autodefrag /dev/mapper/cryptoroot /mnt/$i
done

# for i in {tmp,spool,log,lib/docker/btrfs};
do mount -o subvol=@var/$i,noatime,nodiratime,compress=zstd,space_cache=v2,discard=async,autodefrag /dev/mapper/cryptoroot /mnt/var/$i 
done
```

Disable copy on write

```
for i in {swap,};
do chattr +C /mnt/$i;
done
```

Mount the EFI partition

```
# mkdir /mnt/boot
# mount /dev/nvme0n1p1 /mnt/boot
```

## Base System and `/etc/fstab`

Install Arch Linux (adjust this list to your needs):

```
# pacstrap /mnt linux base neovim intel-ucode btrfs-progs git openssh efibootmgr
```

Generate `/etc/fstab`:

```
# genfstab -U /mnt >> /mnt/etc/fstab
```

Remove hard-coded system subvolume. If not removed, system will ignore btrfs 
default-id setting, which is used by snapper when rolling back:

```
sed -i 's|,subvolid=258,subvol=/@/0/snapshot,subvol=@/0/snapshot||g' $INST_MNT/etc/fstab
```

`chroot` into the new system:

```
# arch-chroot /mnt/
```

### Initramfs

Configure the creation of 
[initramfs](https://wiki.archlinux.org/index.php/Arch_boot_process#initramfs) 
by editing `/etc/mkinitcpio.conf`. Change the line `HOOKS=...` to:

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

The UUID of the root partition can be determined via `blkid`. Create file 
`/boot/loader/entries/arch.conf` containing the uuid like so: 

```
# blkid -s UUID -o value /dev/nvme0n1p2 > /boot/loader/entries/arch.conf
```

And fill it with:

```
title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options cryptdevice=UUID=<UUID-OF-ROOT-PARTITION>:cryptoroot:allow-discards root=/dev/mapper/cryptoroot rootflags=subvol=@/0/snapshot rd.luks.options=discard rw
```

Edit file `/boot/loader/loader.conf` and fill it with:

```
default  arch.conf
timeout  4
console-mode max
editor   no
```

## System Configuration

Get the scripts fomr github
```
# cd ~
# curl https://raw.githubusercontent.com/hmuendel/arch-install/master/base.sh -O
# ./base.sh
```

### Final Steps

Exit `chroot`, unmount partitions and reboot:

```
# exit
# umount -R /mnt
# reboot
```

After the reboot, the `arch-install` files will be in your home directory. 
Continue with `post-install.sh` (important!), the rest can be run in any order.

Have fun with your system!

## Taking snapshots with snapper

### Create manual root filesystem snapshot

```
snapper -c root create --description 'Foo'
```

### Restoring snapshots

To restore a previous snapshot see 
https://wiki.archlinux.org/title/Snapper#Restoring_/_to_its_previous_snapshot.

## References

[1] [Arch My Way 1 | Grundsystem installieren](https://www.youtube.com/watch?v=oT7gs2CmsnQ) (German)

[2] [Arch Linux - UEFI, systemd-boot, LUKS, and btrfs](https://austinmorlan.com/posts/arch_linux_install/)

[3] [Arch Linux Wiki: systemd-boot](https://wiki.archlinux.org/index.php/systemd-boot)

[4] [Arch Linux Wiki: Snapper](https://wiki.archlinux.org/title/Snapper#Restoring_/_to_its_previous_snapshot)
