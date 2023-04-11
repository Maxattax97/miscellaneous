cat /etc/crypttab
ls
pwd
cat *
cd /
ls
cat arch_install/
cat arch_install/*
ls
ls
iwctl
systemctl daemon-reload
systemctl enable /dev/zram0
zramctl --help
vi /etc/systemd/zram-generator.conf
vim /etc/systemd/zram-generator.conf
nvim /etc/systemd/zram-generator.conf
ls
cat arch_install/arch_chroot.log
nvim arch_install/arch_chroot.log
nvim arch_install/arch_chroot.log
systemctl --type swap
ls
cd boot/
ls
cat arch_install/fix_luks.log
ls
nvim vmlinuz-linux-lts
ls
cd EFI/
ls
cd systemd/
ls
cd ../Linux/
ls
cd ../BOOT/
ls
cd ..
ls
cd ..
ls
cd ..
ls
cd etc/
ls
nvim mkinitcpio.conf
nvim /arch_install/arch_chroot.log
mkinitcpio -P
nvim /boot/loader/loader.conf
nvim /boot/loader/entries/arch.conf
nvim /boot/loader/entries/arch-fallback.conf
reboot
ls -lah
cat ~/.bash_history
nvim ~/.bash_history
ls
sudo systemctl status /dev/zram0
systemctl status /dev/zram0
ls /dev/
zramctl
swapon
htop
zsh
zsh
ls
echo $0
zsh
tmux
zsh
ls
ls
ls -lah
ls .local/
ls .lesshst
ls .lesshst -lah
sudo systemctl status reflector
systemctl status reflector
pacman -Ss reflector
cat .bash_history
ls
cat .bash_history
groups
useradd -m mocull
passwd mocull
groups
cat .bash_history
grep -r . /sys/devices/system/cpu/vulnerabilities/
visudo
pacman -S sudo
iwctl
nmcli
systemctl status NetworkManager
systemctl enable NetworkManager
systemctl start NetworkManager
systemctl status NetworkManager
ip a
nmcli
nmcli device wifi connect TellMyWifiLoveHer_2G -a
ip a
ping google.com
ping google.com
export EDITOR=/usr/bin/nvim
visudo
groups
groupadd wheel
usermod -aG wheel mocull
systemctl status sshd
pacman -S reflector
ping google.com
pacman -S reflector
systemctl restart NetworkManager
pacman -S reflector
ping google.com
ping google.com
ping google.com
ping google.com
ip a
nmcli
ip a
nmcli
nmcli
nmcli
ip a
ping google.com
pacman -S reflector
cat /etc/pacman.d/mirrorlist
cat /etc/xdg/reflector/reflector.conf
nvim /etc/xdg/reflector/reflector.conf
systemctl status reflector
systemctl enable reflector
systemctl start reflector
systemctl status reflector
systemctl status reflector.timer
systemctl enable reflector.timer
systemctl start reflector.timer
systemctl status reflector.timer
systemctl status reflector.service
ls
pwd
whoami
ls /home
mkdir src
cd src
ls
pacman -S --needed git base-devel
nvim /etc/xdg/reflector/reflector.conf
reflector --help
reflector --list
reflector --list-countries
nvim /etc/xdg/reflector/reflector.conf
reflector --help
nvim /etc/xdg/reflector/reflector.conf
reflector --help
systemctl start reflector.service
systemctl status reflector.service
cat /etc/pacman.d/mirrorlist
pacman -S --needed git base-devel
pacman -Syu
pacman -S archlinux-keyring
systemctl start reflector.service
pacman -S archlinux-keyring
pacman -Syu
reflector --help
reflector --help -l 25 -f 25 --sort rate
reflector --help -l 25 --sort rate
reflector -l 25 --sort rate
ping google.com
nmcli
nmcli wifi list
nmcli device
nmcli device wlo1
nmcli device --help
nmcli device wifi list
nmcli device wifi connect TellMyWifiLoveHer_2G -a
nmcli
ping google.com
reflector -l 25 --sort rate
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
su mocull
ls
cd ..
ls
cd ..
rm -rf src
ls
nvim /etc/mkinitcpio.conf
mkinitcpio -P
uname -aa
uname -a
pacman -Ss linux
pacman -Ss linux | grep -i install
pacman -Ss nvidia
pacman -S nvidia-dkms nvidia-utils dkms xorg
nvim /etc/pacman.conf
nvim /etc/pacman.conf
pacman -Ss linux
nvim /boot/loader/entries/arch.conf
nvim /etc/pacman.d/hooks/nvidia.hook
ls
cd /etc/pacman.d/
ls
mkdir hooks
mv nvidia.hook hooks/
ls
cd hooks/
ls
cat nvidia.hook
ls
cd ..
ls
nvim hooks/nvidia.hook
:q
cat /etc/X11/xorg.conf.d/
nvidia-xconfig
cat /etc/X11/xorg.conf
cat ~/.bash_history
cat .bash_history
cp .bash_history /arch_install/root_install.log
shutdown 0
