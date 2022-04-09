#!/bin/bash

### Initual part of the Arch linux installation 
# Ideas from EF - Linux https://www.youtube.com/channel/UCX_WM2O-X96URC5n66G-hvw

# Optional keymap configuration
ls /usr/share/kbd/keymaps/i386/qwerty
loadkeys

dumpkeys

localectl list-keymaps
localectl list-locales

ls /usr/share/kbd/consolefonts
setfont ter-c20n

# This is also enabled by default now
systemctl enable sshd.service --now

passwd

ip -c a

# For wireless internet
iwctl
device list
station wlan0 connect mywirelessname

wifi-menu

# Another 
nmtui

# Login to the installation VM
ssh


# Set up local Arch mirrors
pacman -Syyy
pacman -Ql reflector
pacman -S python3 reflector git
reflector --verbose --country SE --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syyy

# another approach
# pacman -S reflector
# cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
# reflector -c "NO" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist

# Sync with ntp servers
timedatectl set-ntp true

# partitioning
lsblk

cfdisk /dev/sda

mkfs.vfat -F32 -n EFI /dev/sda1


# Encryption options
cryptsetup --cipher aes-xts-plain64 --hash sha512 --use-random --verify-passphrase luksFormat /dev/sda2

cryptsetup luksOpen /dev/sda2 root

mkfs.btrfs /dev/mapper/root

mount /dev/mapper/root /mnt

cd /mnt

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@var
cd /
umount /mnt
mount -o noatime,compress=zstd,ssd,discard=async,space_cache=v2,subvol=@ /dev/mapper/root /mnt
mkdir -p /mnt/{boot,home,var}
mount -o noatime,compress=zstd,ssd,discard=async,space_cache=v2,subvol=@home /dev/mapper/root /mnt/home
mount -o noatime,compress=zstd,ssd,discard=async,space_cache=v2,subvol=@var /dev/mapper/root /mnt/var

mount /dev/sda1 /mnt/boot
lsblk

pacstrap /mnt base linux linux-firmware git vim neovim amd-ucode btrfs-progs openssh base-devel dialog os-prober mtools dosfstools

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

# Load modules for the encrypted FS
nvim /etc/mkinitcpio.conf
# Line
# MODULES=(btrfs)
# HOOKS=(base udev autodetect modconf block encrypt filesystems keyboard fsck)

# Then recrete the modules in linux kernel
mkinitcpio -p linux

git clone https://github.com/fanmih/archinstall
