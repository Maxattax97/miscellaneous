# Arch Install

This is the small amount of useful process that survived the old `archiso/`
history dumps. The old scripts were mostly interactive transcripts, so this note
is the cleaned-up version worth keeping.

## Boot ISO

Verify EFI boot and bring up networking.

```bash
ls /sys/firmware/efi/efivars
timedatectl set-ntp true
iwctl
ip link
ping 8.8.8.8
ping google.com
```

## Partitioning And Storage

The old install used:

- EFI system partition for `/boot`
- LVM volume group across one or more disks
- LUKS on the root logical volume
- ext4 root
- optional swapfile later inside the installed system

Typical shape:

1. Partition disk(s)
2. Create PV(s)
3. Create VG, for example `lvm_vg_all`
4. Create LV for root, for example `lvm_lv_root`
5. Encrypt root LV with LUKS
6. Open it as `crypt_root`
7. Format and mount filesystems

Example command skeleton:

```bash
pvcreate /dev/<disk-partition>
vgcreate lvm_vg_all /dev/<disk-partition>
lvcreate -l +100%FREE lvm_vg_all -n lvm_lv_root
cryptsetup luksFormat /dev/mapper/lvm_vg_all-lvm_lv_root
cryptsetup open /dev/mapper/lvm_vg_all-lvm_lv_root crypt_root
mkfs.ext4 /dev/mapper/crypt_root
mkfs.fat -F 32 /dev/<efi-partition>
mount /dev/mapper/crypt_root /mnt
mkdir -p /mnt/boot
mount /dev/<efi-partition> /mnt/boot
```

## Base Install

The old package list was huge and hardware-specific. Keep the base set small,
then add desktop and GPU packages later.

Reasonable base install:

```bash
pacstrap /mnt base linux-lts linux-lts-headers linux-firmware \
  e2fsprogs lvm2 cryptsetup networkmanager neovim man-db man-pages \
  texinfo git tmux zsh curl ripgrep python nodejs xsel weechat \
  newsboat chezmoi efivars zram-generator sudo reflector rsync \
  base-devel wget unzip zip
```

Then generate `fstab` and chroot:

```bash
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
```

## Chroot Setup

Timezone, locale, hostname, keymap:

```bash
ln -sf /usr/share/zoneinfo/America/Indianapolis /etc/localtime
hwclock --systohc
nvim /etc/locale.gen
locale-gen
printf 'LANG=en_US.UTF-8\n' > /etc/locale.conf
printf 'KEYMAP=us\n' > /etc/vconsole.conf
printf '<hostname>\n' > /etc/hostname
```

## mkinitcpio For LUKS + LVM + systemd

The useful part from the old config was the hook order.

Example:

```bash
HOOKS=(base systemd autodetect keyboard sd-vconsole numlock modconf block sd-encrypt lvm2 filesystems fsck)
```

If you need early GPU modules, add them explicitly in `MODULES`, for example on
an NVIDIA system:

```bash
MODULES=(intel_lpss_pci i915 nvidia nvidia_modeset nvidia_uvm nvidia_drm)
```

Rebuild afterwards:

```bash
mkinitcpio -P
```

## systemd-boot

Install and enable updates:

```bash
bootctl install
systemctl enable systemd-boot-update.service
```

The old boot entry pattern looked like this:

```text
title   Arch Linux
linux   /vmlinuz-linux-lts
initrd  /intel-ucode.img
initrd  /initramfs-linux-lts.img
options rd.luks.name=<luks-uuid>=crypt_root root=/dev/mapper/crypt_root nvidia_drm.modeset=1 ibt=off rw
```

Adapt the UUID, mapper names, microcode image, and kernel options to the actual
machine. The checked-in values from the old scripts are machine-specific and not
safe to reuse verbatim.

## Swapfile

The old install created a 20G swapfile after chroot.

```bash
dd if=/dev/zero of=/swapfile bs=1M count=20480 status=progress
chmod 0600 /swapfile
mkswap -U clear /swapfile
swapon /swapfile
```

Then add it to `/etc/fstab`.

## First Boot

Common post-install tasks from the old notes:

```bash
passwd
pacman -S sudo reflector
systemctl enable NetworkManager
systemctl start NetworkManager
useradd -m <user>
passwd <user>
usermod -aG wheel <user>
visudo
```

## Dotfiles And User Setup

Once the user account is ready:

```bash
git clone git@github.com:Maxattax97/miscellaneous.git miscellaneous-config
cd miscellaneous-config
./install.sh
```

## Pacman Cache Cleanup

After a while the pacman cache will accumulate. Install `paccache` and automate
cleanup.

```bash
sudo pacman -Syu pacman-contrib
sudo systemctl enable paccache.timer
sudo systemctl start paccache.timer
```
