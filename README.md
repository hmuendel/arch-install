# Arch Basic Install Commands-Script

In this repository you will find packages-scripts for the base install of Arch Linux and the Gnome, i3 and sway environments.
Modify the packages to your liking and then run with ./scriptname.
Remember that the first part of the Arch Linux install is manual, that is you will have to partition, format and mount the disk yourself. Install the base packages and make sure to inlcude git so that you can clone the repository in chroot.

A small summary:
(see https://www.youtube.com/watch?v=co5V2YmFVEE&t=838s)

1. If needed, load your keymap
2. Refresh the servers with pacman -Syy
3. Partition the disk (btrfs)
4. Format the partitions (btrfs)
5. Mount the partitions
6. Install the base packages into /mnt (`pacstrap /mnt linux base linux-firmware neovim intel-ucode btrfs-progs git`)
7. Generate the FSTAB file with genfstab -U /mnt >> /mnt/etc/FSTAB
8. Chroot in with arch-chroot /mnt
9. Download the git repository with git clone https://git.sr.ht/~chmanie/arch-install
10. cd arch-install
11. run with ./base.sh
