#!/bin/bash
set_os_vars(){
	OS_ICON='\uf31a'
	OS_NAME='Linux'

	# Add in an argument in case we want to check that too.
	text="$(cat /etc/*-release)$(cat /proc/version)$(lsb_release -i)"
	text="$(echo "$text" | tr '[:upper:]' '[:lower:]')"

	case "$text" in
		*alpine*)
			OS_ICON='\uf300'
			OS_NAME="Alpine"
			;;
		*aosc*)
			OS_ICON='\uf301'
			OS_NAME="AOSC"
			;;
		*apple*)
			OS_ICON='\uf302'
			OS_NAME="OSX"
			;;
		*arch*)
			OS_ICON='\uf303'
			OS_NAME="Arch"
			;;
		*centos*)
			OS_ICON='\uf304'
			OS_NAME="CentOS"
			;;
		*coreos*)
			OS_ICON='\uf305'
			OS_NAME="CoreOS"
			;;
		*debian*)
			OS_ICON='\uf306'
			OS_NAME="Debian"
			;;
		*devuan*)
			OS_ICON='\uf307'
			OS_NAME="Devuan"
			;;
		*docker*)
			OS_ICON='\uf308'
			OS_NAME="Docker"
			;;
		*elementary*)
			OS_ICON='\uf309'
			OS_NAME="Elementary"
			;;
		*fedora*)
			OS_ICON='\uf30a'
			OS_NAME="Fedora"
			;;
		*bsd*)
			OS_ICON='\uf30c'
			OS_NAME="FreeBSD"
			;;
		*gentoo*)
			OS_ICON='\uf30d'
			OS_NAME="Gentoo"
			;;
		*mint*)
			OS_ICON='\uf30e'
			OS_NAME="Mint"
			;;
		*mageia*)
			OS_ICON='\uf310'
			OS_NAME="Mageia"
			;;
		*mandriva*)
			OS_ICON='\uf311'
			OS_NAME="Mandriva"
			;;
		*manjaro*)
			OS_ICON='\uf312'
			OS_NAME="Manjaro"
			;;
		*nixos*)
			OS_ICON='\uf313'
			OS_NAME="NixOS"
			;;
		*suse*)
			OS_ICON='\uf314'
			OS_NAME="OpenSUSE"
			;;
		*raspberry*)
			OS_ICON='\uf315'
			OS_NAME="Raspberry Pi"
			;;
		*redhat*)
			OS_ICON='\uf316'
			OS_NAME="RedHat"
			;;
		*sabayon*)
			OS_ICON='\uf317'
			OS_NAME="Sabayon"
			;;
		*slackware*)
			OS_ICON='\uf318'
			OS_NAME="Slackware"
			;;
		*ubuntu*)
			OS_ICON='\uf31c'
			OS_NAME="Ubuntu"
			;;
		*windows*)
			OS_ICON='\uf17a'
			OS_NAME="Windows"
			;;
		*android*)
			OS_ICON='\uf17b'
			OS_NAME="Android"
			;;
		esac

	printf "$OS_ICON $OS_NAME\n"
	export OS_ICON
	export OS_NAME
}

set_os_vars
