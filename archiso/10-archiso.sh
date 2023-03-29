echo "Did you boot into EFI mode?"
ls /sys/firmware/efi/efivars

echo "Connect to the Wifi"
iwctl

echo "Are you connected to the internet?"
ip link
ping 8.8.8.8
ping google.com

echo "Hooking up NTP"
timedatectl set-ntp true

echo "Setup LVM and LUKS"
#fdisk -l
#fdisk /dev/nvme0n1
#parted /dev/nvme0n1
#fdisk /dev/nvme0n1
#fdisk /dev/nvme1n1
#fdisk -l
#cryptsetup benchmark
#fdisk -;
#fdisk -l
#pvcreate /dev/nvme0n1p2
#pvs
#pvcreate /dev/nvme1n1p1
#pvs
#pvresize /dev/nvme0n1p2
#vgcreate lvm_vg_all /dev/nvme0n1p2 /dev/nvme1n1p1
#vgs
#fdisk -l
#lvs
#vgs
#vgs --help
#vgs --units GB
#vgs --units G
#lvcreate -L 1509G lvm_vg_all -n lvm_lv_root
#vgs --units GB
#vgs --units G
#lvcreate -L 1508G lvm_vg_all -n lvm_lv_root
#lvcreate -L 1500G lvm_vg_all -n lvm_lv_root
#lvcreate -l +100%FREE lvm_vg_all -n lvm_lv_root
#lvs
#lvresize -l -1G --resizefs lvm_vg_all/lvm_lv_root
#lvresize -L -1G --resizefs lvm_vg_all/lvm_lv_root
#lvresize -L -1G
#lvresize -L -1G lvm_lv_root
#lvresize -L -1G lvm_vg_all/lvm_lv_root
#lvs
#lvs -u G
#lvs --unit G
#lsblk
#ls /dev/mapper
#ls /dev/mapper/lvm_vg_all-lvm_lv_root
## cryptsetup open --type plain -d /dev/urandom /dev/mapper/lvm_vg_all-lvm_lv_root
#cryptsetup --help
#man cryptsetup
#cryptsetup --help
#lvs
#lvresize -L -1G lvm_vg_all/lvm_lv_root
#lvcreate -l +100%FREE lvm_vg_all -n lvm_lv_boot
#lvs
#lvresize -L -1G lvm_vg_all/lvm_lv_boot
#lvs
#lsmod
#lsmod | grep -i dm_crypt
#insmod dm_crypt
#pacman -Ss dm_crypt
#lsmod | grep -i crypt
#pacman -Ss crypt
#pacman -Sy
#pacman -Ss crypt
#pacman -Ss dm_crypt
#pacman -Ss dm-\crypt
#pacman -Ss dm-crypt
#lsmod | grep -i dm_crypt
#lsmod | grep -i crypt
#cryptsetup --help
#cryptsetup benchmark
#cryptsetup --version
#cryptsetup luksFormat /dev/mapper/lvm_vg_all-lvm_lv_root
#cryptsetup luksFormat /dev/mapper/lvm_vg_all-lvm_lv_root
#cryptsetup open /dev/mapper/lvm_vg_all-lvm_lv_root crypt_root
#ls /dev/mapper
#mkfs -t ext4 /dev/mapper/crypt_root
#cryptsetup luksDump /dev/mapper/lvm_vg_all-lvm_lv_root
#mkfs -t ext4 /dev/mapper/lvm_vg_all-lvm_lv_boot
#fdisk -l
## mkfs -F 32 /dev/nvme0n1p1
#fdisk -l
## mkfs -F 32 /dev/nvme0n1p1

echo "Mount up"
#mount /dev/mapper/crypt_root /mnt
#mount /dev/nvme0n1p1 /mnt/boot
#mkdir /mnt/boot
#mount /dev/nvme0n1p1 /mnt/boot
#mkfs -F 32 /dev/nvme0n1p1
#mkfs.fat -F 32 /dev/nvme0n1p1
#mount /dev/nvme0n1p1 /mnt/boot
#ls /mnt

echo "Install base packages"
pacstrap /mnt base linux-lts linux-lts-headers linux-firmware e2fsprogs lvm2 cryptsetup iproute2 networkmanager neovim man-db man-pages texinfo git tmux zsh htop curl ripgrep python nodejs xclip weechat newsboat neofetch chezmoi efivars zram-generator sudo reflector rsync base-devel dkms xorg xorg-server xorg-apps xorg-init xorg-twm xorg-xclock xterm wget unzip zip python python-pip rubygems chromium firefox vulcan-icd-loader vulkan-tools xdg-user-dirs thermald ethtool smartmontools gsmartcontrol pipewire wireplumber helvum pipewire-jack pipewire-alsa pipewire-pulse xdg-desktop-portal xdg-desktop-portal-gtk util-linux chrony
pacstrap /mnt tlp
pacstrap /mnt amd-ucode
pacstrap /mnt intel-ucode xf86-video-intel mesa
pacstrap /mnt nvidia-dkms nvidia-utils nvtop nvidia-settings

echo "Generate fstab"
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab

echo "Enter the chroot"
arch-chroot /mnt

echo "Exit the chroot"
#echo $KEYMAP
#localectl status
#localectl list-keymaps
#localectl list-keymaps | grep -i US
