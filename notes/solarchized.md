Configure all of this using a system like KBuild?

# Base
 - X AwesomeWM
 - X Updated fork of Compton compositor, possibly Kawase blur
 - LightDM with lots of customization?
 - Zen (Performance) or Hardened (Security) patched Linux Kernel
 - X Refind bootloader?

# Security
 - X Consistent use of GPG keys, including signed email and git commits
 - LUKS encryption: BTRFS root FS with automated snapshots, EXT4 for everything else.
 - Encrypted boot for GRUB?
 - USBGuard
 - Secureboot enabled
 - Git using SSH keys
 - UFW
 - A custom DNS with DNSSEC, DNSCrypt, etc.
 - Background OpenVPN tunnel?
 - Stretch: Prevent rubber hose attacks via hidden volumes
 - Stretch: SELinux
    - If not this, then AppArmor?
 - Stretch: Buy a Radeon graphics card to use FLOSS drivers (AMD Radeon VII)

# Aesthetic
 - Solarized Dark theme throughout, with hints of Solarized Light where needed (e.g. Firefox?)
 - Powerline bars
 - Grid wallpaper which fits nicely with ...
 - Conky display
     - CPU usage
     - RAM usage
     - Temperatures
     - Clock speeds
     - Tasks
     - Top processes
     - Power (AC, Battery)
     - Uptime
     - Date
     - Time
     - Network status
     - Network usage
     - Weather
     - Music
     - Stretch: geolocation
     - Stretch: circular process tree (front and center)
     - Stetch: music beat wave indicator
 - Custom Plymouth and GRUB/Refind themes
 - X FreeFont or Roboto, Hack Nerd Font
 - X Papirus icon theme, Possibly some variant of La Capitaine
 - Top, left aligned system bars
 - dmenu-type / rofi application access
 - X Glass fade (Kawase?)

# Terminal Loadout
 - X ZSH
 - X Tmux
     - nearly everywhere
     - possibly started at boot
 - X Neovim
 - X Ranger
 - ncmpcpp + mpd
 - gtop
 - Weechat
 - Neomutt + Protonmail Bridge
 - (torrent client)

# Primary Applications
 - Urxvt
 - Rofi
 - Firefox Nightly (with theme tweaks, RAM optimization)
 - Steam
 - Signal
 - Rambox
 - Discord

# Workflow
 - Internet
     - Firefox
 - Gaming
     - Steam
     - Discord
 - Social
     - Signal
     - Rambox
 - Network Services
     - Nextcloud
     - Torrent
 - Pre-align some terminals with programs to edges of workspaces, leaving open room

# Functions
 - Idle target service which triggers things like crypto mining
 - Powersaves based on hardware profile
 - Pacman optimizations, including automated mirror selection, and placement of cache.
 - Scheduled BTRFS scrubbing
 - Factors taken to improve SSD life
 - Store sensitive configuration in ZSH's blackbox.
 - Stretch: Ability to switch to light mode with an easy toggle (e.g. on key combo) with possibly day-night cycle
