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

# mkdir @var/lib
# btrfs sub create @var/lib/docker
# umount /mnt

```

Mount the subvolumes:

```


cd ~
umount /mnt
# FIXME: REPLACE all of the mount options with this one
# mount -o noatime,nodiratime,compress=zstd,space_cache=v2,discard=async,autodefrag,subvol=@/0/snapshot /dev/mapper/cryptoroot /mnt

mkdir -p /mnt/{.snapshots,home,root,srv,tmp,usr/local,swap}

mkdir -p /mnt/var/{tmp,spool,log,lib/docker}
mount /dev/mapper/cryptoroot /mnt/.snapshots/ -o subvol=@,compress-force=zstd,noatime,space_cache=v2

# mount subvolumes
# separate /{home,root,srv,swap,usr/local} from root filesystem
for i in {home,root,srv,swap,usr/local};
do mount /dev/mapper/cryptoroot /mnt/$i -o subvol=@$i,compress-force=zstd,noatime,space_cache=v2;
done

# separate /var/{tmp,spool,log} from root filesystem
for i in {tmp,spool,log};
do mount /dev/mapper/cryptoroot /mnt/var/$i -o subvol=@var/$i,compress-force=zstd,noatime,space_cache=v2;
done

# mount -o noatime,nodiratime,compress=zstd,space_cache,discard=async,autodefrag,subvol=@ /dev/mapper/cryptoroot /mnt
# mkdir -p /mnt/{boot,home,var/cache/pacman/pkg,/var/lib/docker/btrfs,.snapshots,btrfs}
# mount -o noatime,nodiratime,compress=zstd,space_cache,discard=async,autodefrag,subvol=@home /dev/mapper/cryptoroot /mnt/home
# mount -o noatime,nodiratime,compress=zstd,space_cache,discard=async,autodefrag,subvol=@pkg /dev/mapper/cryptoroot /mnt/var/cache/pacman/pkg
# mount -o noatime,nodiratime,compress=zstd,space_cache,discard=async,autodefrag,subvol=@snapshots /dev/mapper/cryptoroot /mnt/.snapshots
# mount -o noatime,nodiratime,compress=zstd,space_cache,discard=async,autodefrag,subvol=@docker /dev/mapper/cryptoroot /mnt/var/lib/docker/btrfs
# mount -o noatime,nodiratime,compress=zstd,space_cache,discard=async,autodefrag,subvolid=5 /dev/mapper/cryptoroot /mnt/btrfs
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

Remove hard-coded system subvolume. If not removed, system will ignore btrfs default-id setting, which is used by snapper when rolling back:

```
sed -i 's|,subvolid=258,subvol=/@/0/snapshot,subvol=@/0/snapshot||g' $INST_MNT/etc/fstab
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

Copy your `.ssh` folder from a backup into `/root`. Then clone the install repository:

```
# cd ~ && git clone https://git.sr.ht/~chmanie/arch-install
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

## Taking snapshots with snapper

### Create root filesystem snapshot
```
snapper -c root create
```
Additional options for create, such as --description, see snapper help.

### Rollback root filesystem
If the system is broken, reboot, select a bootable entry in GRUB snapshot list. Your computer will then boot with a read-only root filesystem with a writable OverlayFS on it.

Run `snapper -c root list` to find out which snapshot you want to rollback to.

```
 # | Type   | Pre # | Date                            | User | Cleanup | Description        | Userdata
---+--------+-------+---------------------------------+------+---------+--------------------+---------
0- | single |       |                                 | root |         | current            |
1  | single |       | Tue 09 Feb 2021 09:44:55 PM +08 | root | number  | boot               |
2  | single |       | Tue 09 Feb 2021 09:49:30 PM +08 | root | number  | boot               |
3  | pre    |       | Tue 09 Feb 2021 09:49:51 PM +08 | root | number  | pacman -S dropbear |
4  | post   |     3 | Tue 09 Feb 2021 09:49:52 PM +08 | root | number  | dropbear           |
```

If we want to rollback to 3, run `snapper --ambit classic rollback 3` to rollback.

```
Ambit is classic.
Creating read-only snapshot of current system. (Snapshot 5.)
Creating read-write snapshot of snapshot 3. (Snapshot 6.)
Setting default subvolume to snapshot 6.
```

FIXME: This should be a manual for systemd-boot

Remember the new default subvolume number 6. This will be the new / the computer will boot into. Now run grub-mkconfig -o /boot/grub/grub.cfg to let GRUB know about the new snapshots. Reboot, select snapshot 6 from GRUB menu.

After reboot, run

```
grub-install
grub-mkconfig -o /boot/grub/grub.cfg
```
to make snapshot 6 the default boot volume. Then you won't need to manually select it again on next reboot.

## References

[1] [Arch My Way 1 | Grundsystem installieren](https://www.youtube.com/watch?v=oT7gs2CmsnQ) (German)

[2] [Arch Linux - UEFI, systemd-boot, LUKS, and btrfs](https://austinmorlan.com/posts/arch_linux_install/)

[3] [Arch Linux Wiki: systemd-boot](https://wiki.archlinux.org/index.php/systemd-boot)
