#!/bin/bash

### Final part of the Arch linux installation 
# Ideas from EF - Linux https://www.youtube.com/channel/UCX_WM2O-X96URC5n66G-hvw
# this is meant to run as a script after the partitions are ready and mounted

# Set timezone
timedatectl set-timezone Europe/Oslo
ln -sf /usr/share/zoneinfo/Europe/Oslo /etc/localtime
hwclock --systohc

# Set language and locales
# Line below removes the pound sign from timezone
sed -i '178s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
# line below sets the KEYMAP so we do not need it
# echo "KEYMAP=de_CH-latin1" >> /etc/vconsole.conf

# Set host and hostname
echo "archapril2022" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 archapril2022.localdomain archapril2022" >> /etc/hosts

echo root:123123 | chpasswd

# You can add xorg to the installation packages, I usually add it at the DE or WM install script
# You can remove the tlp package if you are installing on a desktop or vm
# We also remove the grub package as we will install the boot manager with systemdboot
# We also remove the following packages as they are for xwindows and we are building headless
# xdg-user-dirs xdg-utils cups hplip alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bluez bluez-utils

# install all packages
pacman -S efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools base-devel linux-headers avahi gvfs gvfs-smb nfs-utils inetutils dnsutils bash-completion openssh rsync reflector acpi acpi_call virt-manager qemu qemu-arch-extra edk2-ovmf bridge-utils dnsmasq vde2 openbsd-netcat iptables-nft ipset firewalld flatpak sof-firmware nss-mdns acpid os-prober ntfs-3g terminus-font

# pacman -S --noconfirm xf86-video-amdgpu
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

# Also commenting out these two lines because we will not use grub
# grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB #change the directory to /boot/efi is you mounted the EFI partition at /boot/efi
# grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
# systemctl enable bluetooth
# systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
# systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable libvirtd
systemctl enable firewalld
systemctl enable acpid

useradd -m zz
echo zz:123123 | chpasswd
usermod -aG libvirt zz

echo "zz ALL=(ALL) ALL" >> /etc/sudoers.d/zz

# actually not done yet! we need to create the bootloader lines
printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"




