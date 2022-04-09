#! /bin/bash

# install bootloader filestructure
bootctl --path=/boot install

nvim /boot/loader/loader.conf
# edit the file with the lines below:
# timeout 5 
# default arch
#console-mode keep

# creating the arch entry
nvim /boot/loader/entries/arch.conf
# file contents below:
# title Arch Linux
# linux /vmlinuz-linux
# initrd /initramfs-linux.img
# options cryptdevice=UUID=6ccc9ed3-0582-44e2-b941-b861b38e96c3:root root=UUID=45fda329-1856-4356-8ad4-c0cde9ae7cd6 rootflags=subvol=@ rw

# To get the UUIDs append them
blkid /dev/sda2 >> /boot/loader/entries/arch.conf
blkid /dev/mapper/root >> /boot/loader/entries/arch.conf
# if you want just the UUID
blkid -s PARTUUID -o value /dev/sda2

# Creating another entry in the boot menu
cp /boot/loader/entries/arch.conf /boot/loader/entries/arch-fallback.conf
vim /boot/loader/entries/arch-fallback.conf
# the only line we have to change here is the initrd entry
# initrd /initramfs-linux-fallback.img


# updating the bootloader
bootctl --path=/boot update

# now unmounting
exit
umount -R /mnt

reboot


# after booting to the system
git clone https://aur.archlinux.org/paru-bin
makepkg -si

paru -S timeshift-bin timeshift-autosnap zramd

sudo systemctl enable --now zramd
sudo nvim /etc/default/zramd
