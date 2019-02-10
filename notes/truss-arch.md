# Base
 - AwesomeWM, possibly i3-gaps
 - Updated fork of Compton compositor, possibly Kawase blur
 - LightDM with lots of customization?

# Security
 - Consistent use of GPG keys, including signed email and git commits
 - LUKS encryption: BTRFS root FS with automated snapshots, EXT4 for everything else.
 - Encrypted boot for GRUB?
 - USBGuard
 - Secureboot enabled
 - Git using SSH keys
 - UFW
 - A custom DNS with DNSSEC, DNSCrypt, etc.
 - Background OpenVPN tunnel?
 - Stretch: SELinux
    - If not this, then AppArmor?
 - Stretch: Buy a Radeon graphics card to use FLOSS drivers

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
 - Custom Plymouth and GRUB themes
 - FreeFont or Roboto, Hack Nerd Font
 - Papirus icon theme, Possibly some variant of La Capitaine
 - Top, left aligned system bars
 - dmenu-type application access
 - Glass fade (Kawase?)

# Terminal Loadout
 - ZSH
 - Tmux
 - Neovim
 - Ranger
 - ncmpcpp + mpd
 - gtop
 - Weechat 
 - Neomutt + Protonmail Bridge
 - (torrent client)

# Primary Applications
 - Urxvt
 - Firefox (with theme tweaks, RAM optimization)
 - Steam
 - Signal
 - Rambox
 - Discord

# Workflow
 - Internet
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
 - Ability to switch to light mode with an easy toggle (e.g. on key combo) with possibly day-night cycle
 - Pacman optimizations, including automated mirror selection
 - Scheduled BTRFS scrubbing
 - Factors taken to improve SSD life
