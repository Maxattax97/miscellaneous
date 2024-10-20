ln -sf /usr/share/zoneinfo/America/Indianapolis /etc/localtime
hwclock --systohc
locale-gen
nvim /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo 'mocull-nocturne' > /etc/hostname
nvim /etc/mkinitcpio.conf
cat /etc/mkinitcpio.conf
cat /etc/mkinitcpio.conf | grep -i HOOK
# base systemd autodetect keyboard sd-vconsole modconf block sd-encrypt lvm2 filesystems fsck
nvim /etc/mkinitcpio.conf
nvim /etc/mkinitcpio.conf
nvim /etc/systemd/system.conf
bootctl --help
bootctl status
mkinitcpio -P
ls /usr/share/kbd/keymaps/**/*.map.gz
echo $KEYMAP
echo 'KEYMAP=us' > /etc/vconsole.conf
pacman -Ss linux-firmware
mkinitcpio -P
passwd
efivar --list
bootctl statu
bootctl status
ls /sys/firmware/efi/efivars/
ls
ls arch_install/
history
history >> /arch_install/arch_chroot.log
bootctl install
systemctl enable systemd-boot-update.service
# investigate systemd-boot-pacman-hook
nvim /boot/loader/entries/arch.conf
cat /boot/loader/entries/arch.conf
nvim /etc/mkinitcpio.conf
#dd if=/dev/zero of=/swapfile bs=1M count=
free
#dd if=/dev/zero of=/swapfile bs=1M count=20480 status=progress
dd if=/dev/zero of=/swapfile bs=1M count=20480 status=progress
chmod 0600 /swapfile
mkswap -U clear /swapfile
swapon /swapfile
nvim /etc/fstab
filefrag -v /swapfile
filefrag -v /swapfile  | head
nvim /boot/loader/entries/arch.conf
nvim /boot/loader/entries/arch.conf
lsmod
lsmod | grep -i intel
lsmod | grep -i intel_lpss
nvim /etc/mkinitcpio.conf
mkinitcpio -P
cd /boot/loader/entries
ls
cp arch.conf arch-fallback.conf
nvim arch-fallback.conf
history
history > /arch_install/arch_chroot.log
