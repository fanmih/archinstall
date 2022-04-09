#!/bin/bash

ls /usr/share/kbd/keymaps/i386/qwerty
loadkeys 

dumpkeys

localectl list-keymaps
localectl list-locales

ls /usr/share/kbd/consolefonts
setfont ter-c20n

systemctl enable sshd.service --now

passwd

ip -c a

# For wireless internet
iwctl
device list
station wlan0 connect mywirelessname

wifi-menu


# Login to the installation VM
ssh


# Set up local Arch mirrors
pacman -Syyy

pacman -Ql reflector

pacman -S python3
pacman -S reflector
reflector --verbose --country SE --latest 5 --sort rate --save /etc/pacman.d/mirrorlist

pacman -Syyy

pacman -S reflector
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
reflector -c "NO" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist

# Sync with ntp servers
timedatectl set-ntp true

lsblk

