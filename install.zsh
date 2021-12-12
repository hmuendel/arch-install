#! /usr/bin/zsh 
set -Eeuxo pipefail

if [[ -z "${CRYPT_PW}" ]]; then
    echo CRYPT_PW must be set
    exit
fi

# Zapping the old partition table and creating a new one and the partition
sgdisk -Z /dev/nvme0n1
sgdisk -a1 -n1:2048:1128447 -t1:EF00 -N2  /dev/nvme0n1
sgdisk -p /dev/nvme0n1

echo -n "${CRYPT_PW}" | cryptsetup -q luksFormat /dev/nvme0n1p2 -
echo -n "${CRYPT_PW}" | cryptsetup open /dev/nvme0n1p2 cryptoroot -d -

mkfs.vfat -F32 -n EFI /dev/nvme0n1p1 
mkfs.btrfs -f -L ROOT /dev/mapper/cryptoroot


mount /dev/mapper/cryptoroot /mnt
cd /mnt

btrfs subvolume create @
mkdir @/0
btrfs subvolume create @/0/snapshot

for i in {home,root,srv,usr,usr/local,swap,var};
    do btrfs subvolume create @$i;
done

for i in {tmp,spool,log};
    do btrfs subvolume create @var/$i;
done

mkdir -p @var/lib/docker
btrfs sub create @var/lib/docker/btrfs

cd ~
umount /mnt

mount -o noatime,nodiratime,compress=zstd,space_cache=v2,discard=async,autodefrag,subvol=@/0/snapshot /dev/mapper/cryptoroot /mnt

mkdir -p /mnt/{.snapshots,home,root,srv,tmp,usr/local,swap}
mkdir -p /mnt/var/{tmp,spool,log,lib/docker/btrfs}

mount -o noatime,nodiratime,compress=zstd,space_cache=v2,discard=async,autodefrag,subvol=@ /dev/mapper/cryptoroot /mnt/.snapshots/ 

for i in {home,root,srv,swap,usr/local};
    do mount -o subvol=@$i,noatime,nodiratime,compress=zstd,space_cache=v2,discard=async,autodefrag /dev/mapper/cryptoroot /mnt/$i
done

 for i in {tmp,spool,log,lib/docker/btrfs};
    do mount -o subvol=@var/$i,noatime,nodiratime,compress=zstd,space_cache=v2,discard=async,autodefrag /dev/mapper/cryptoroot /mnt/var/$i 
done

# Disable copy on write
chattr +C /mnt/swap

# Mount the EFI partition
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot

pacman -Syy
pacstrap /mnt linux base neovim intel-ucode btrfs-progs efibootmgr zsh

# Generate `/etc/fstab`:
genfstab -U /mnt >> /mnt/etc/fstab

#Remove hard-coded system subvolume. If not removed, system will ignore btrfs 
# default-id setting, which is used by snapper when rolling back:

sed -i 's|,subvolid=[0-9]*,subvol=/@/0/snapshot||' /mnt/etc/fstab

# updating repositories

curl https://raw.githubusercontent.com/hmuendel/arch-install/master/boot-config.zsh -o /mnt/root/boot-config.zsh
chmod +x /mnt/root/boot-config.zsh

curl https://raw.githubusercontent.com/hmuendel/arch-install/master/packages.zsh -o /mnt/root/packages.zsh
chmod +x /mnt/root/packages.zsh

curl https://raw.githubusercontent.com/hmuendel/arch-install/master/config.zsh -o /mnt/root/config.zsh
chmod +x /mnt/root/config.zsh

curl https://raw.githubusercontent.com/hmuendel/arch-install/master/user-config.zsh -o /mnt/root/user-config.zsh
chmod +x /mnt/root/user-config.zsh

# `chroot` into the new system:
arch-chroot /mnt/ /root/boot-config.zsh
arch-chroot /mnt/ /root/packages.zsh
arch-chroot /mnt/ /root/config.zsh
arch-chroot /mnt/ /root/user-config.zsh
