#!/bin/bash

menu(){
	BLUE=`echo '\033[94m'`
    	GREEN=`echo '\033[92m'`
    	RED=`echo '\033[31m'`
    	YELLOW=`echo '\033[93m'`
	REST=`echo "\033[m"`
	echo -e "${GREEN} ++++++++++++++++++++++++++++++++++++++++++++++++++++ ${REST}"
	echo -e "${GREEN} For Debian based, Arch and Manjaro Linux ${REST}"
	echo -e "${GREEN} Not For UBUNTU Based....${REST}"
	echo -e "${GREEN} ++++++++++++++++++++++++++++++++++++++++++++++++++++ ${REST}"
	echo -e "${BLUE} 1) ${RED} GDM-Arch ${REST}"
	echo -e "${BLUE} 2) ${RED} GDM-Debian ${REST}"
	echo -e "${BLUE} 3) ${RED} GDM-Manjaro ${REST}"
	echo -e "${BLUE} 4) ${RED} LIGHTDM-Arch ${REST}"
        echo -e "${BLUE} 5) ${RED} LIGHTDM-Debian ${REST}"
        echo -e "${BLUE} 6) ${RED} LIGHTDM-Manjaro ${REST}"
	echo -e "${BLUE} 7) ${RED} SDDM-Arch ${REST}"
        echo -e "${BLUE} 8) ${RED} SDDM-Debian ${REST}"
        echo -e "${BLUE} 9) ${RED} SDDM-Manjaro ${REST}"
	echo -e "${GREEN} +++++++++++++++++++++++++++++++++++++++++++++++++++ ${REST}"
	echo -e " Enter The Choice According To You DE Only.. ${RED} To Exit Press ENTER ${REST}"
	read opt
}

function gdm-arch(){
	pacman -S nvidia nvidia-dkms nvidia-settings
	mkdir /etc/pacman.d/hooks
	mv nvidia.hook /etc/pacman.d/hooks
	mv optimus.conf /etc/X11/xorg.conf.d/optimus.conf
	echo "Remove auto generated nvidia Configuration file -->> Remove From /etc/modprobe.d/ and /etc/X11/xorg.conf.d/"
	mv blacklist-nouveau /etc/modprobe.d/nvidia.conf
	mv nvidia-drm.conf /etc/modprobe.d/nvidia-drm.conf
	mv optimus.sh /usr/local/bin/optimus.sh
	chmod a+rx /usr/local/bin/optimus.sh
	mv optimus.desktop /usr/local/share/optimus.desktop
	ln -s /usr/local/share/optimus.desktop /usr/share/gdm/greeter/autostart/optimus.desktop
	ln -s /usr/local/share/optimus.desktop /etc/xdg/autostart/optimus.desktop
	whiptail --title "Change Required" --msgbox "Edit PCI value Accordingly before You proceed -->>> Edit /usr/local/bin/optimus.sh and add your system PCI value" 8 78
}

function gdm-debian(){
	whiptail --title "Warning" --msgbox "Before Running this script Logout And Press Ctrl+Alt+F2 and run : systemctl stop gdm" 8 78
	whiptail --title "Attention" --msgbox "After Running systemctl stop gdm. Got Black Screen Just Press Ctrl+Alt+F2 .... " 8 78
	if (whiptail --title "Is GDM Stopped?" --yesno "If GDM is Stopped then press YES else NO" 8 78); then
    		apt install linux-headers-$(uname -r) nvidia-settings nvidia-driver nvidia-xconfig -Vy
		mv nouveau /etc/modprobe.d/nvidia-blacklists-nouveau.conf
		update-initramfs -u
		clear
		rmmod nouveau
		lsmod | grep -i nouveau
		modprobe nvidia-drm
		mv xorg /etc/X11/xorg.conf
		nvidia-xconfig --query-gpu-info | grep 'BusID : ' | cut -d ' ' -f6
		mv optimus /usr/share/gdm/greeter/autostart/optimus.desktop
		cp /usr/share/gdm/greeter/autostart/optimus.desktop /etc/xdg/autostart/optimus.desktop
		echo " If You Can See Only PCI Value Then Do This:"
		echo "Edit PCI value Accordingly before You proceed -->>> Edit /etc/X11/xorg.conf and add your system PCI value"
	else
		clear
    		echo "Run This Command Before you proceed : systemctl stop gdm "
	fi
}

function gdm-manjaro(){
	whiptail --title "Attention Required" --msgbox "Do uninstall and remove Old Nvidia Driver Packages and Settings" 8 78
	if(whiptail --title "Are You Ready to proceed?" --yesno "If You are Ready to proceed then press YES else NO" 8 78); then
		mhwd -i pci video-nvidia-440xx
		mkdir /etc/pacman.d/hooks
		mv nvidia.hook /etc/pacman.d/hooks
		mv optimus.conf /etc/X11/xorg.conf.d/optimus.conf
		whiptail --title "Change Required" --msgbox " Remove auto generated nvidia Configuration file -->> Remove From /etc/modprobe.d/ and /etc/X11/xorg.conf.d/" 8 78
		mv blacklist-nouveau /etc/modprobe.d/nvidia.conf
		mv nvidia-drm.conf /etc/modprobe.d/nvidia-drm.conf
		mv optimus.sh /usr/local/bin/optimus.sh
		chmod a+rx /usr/local/bin/optimus.sh
		mv optimus.desktop /usr/local/share/optimus.desktop
		ln -s /usr/local/share/optimus.desktop /usr/share/gdm/greeter/autostart/optimus.desktop
		ln -s /usr/local/share/optimus.desktop /etc/xdg/autostart/optimus.desktop
		whiptail --title "Change Required" --msgbox "Edit PCI value Accordingly before You proceed -->>> Edit /usr/local/bin/optimus.sh and add your system PCI value" 8 78
	else
		clear
		whiptail --title "Do It then run again" --msgbox "Remove all Previously Installed Nvidia Stuff" 8 78
	fi
}

function lightdm-arch(){
	pacman -S nvidia nvidia-dkms nvidia-settings
	mkdir /etc/pacman.d/hooks
	mv nvidia.hook /etc/pacman.d/hooks
	mv optimus.conf /etc/X11/xorg.conf.d/optimus.conf
	whiptail --title "Change Required" --msgbox " Remove auto generated nvidia Configuration file -->> Remove From /etc/modprobe.d/ and /etc/X11/xorg.conf.d/" 8 78
	mv blacklist-nouveau /etc/modprobe.d/nvidia.conf
	mv nvidia-drm.conf /etc/modprobe.d/nvidia-drm.conf
	mv display_setup /etc/lightdm/display_setup.sh
	chmod +x /etc/lightdm/display_setup.sh
	echo " If You Can See Only PCI Value Then Do This:"
	echo "Edit PCI value Accordingly before You proceed -->>> Edit /etc/X11/xorg.conf and add your system PCI value"
	echo "---------------------------------------------------------------------------------------------------------"
	echo "Edit and Add Following: /etc/lightdm/lightdm.conf"
	echo "Add This At ->> [Seat:*] ... display-setup-script=/etc/lightdm/display_setup.sh"
	echo "---------------------------------------------------------------------------------------------------------"
	whiptail --title "Change Required" --msgbox "Edit PCI value Accordingly before You proceed -->>> Edit /usr/local/bin/optimus.sh and add your system PCI value" 8 78
}

function lightdm-debian(){
	whiptail --title "Warning" --msgbox "Before Running this script Logout And Press Ctrl+Alt+F2 and run : systemctl stop lightdm" 8 78
	whiptail --title "Attention" --msgbox "After Running systemctl stop lightdm. Got Black Screen Just Press Ctrl+Alt+F2 .... " 8 78
	if (whiptail --title "Is LIGHTDM Stopped?" --yesno "If LIGHTDM is Stopped then press YES else NO" 8 78); then
    		apt install linux-headers-$(uname -r) nvidia-settings nvidia-driver nvidia-xconfig -Vy
    		mv nouveau /etc/modprobe.d/nvidia-blacklists-nouveau.conf
    		update-initramfs -u
		clear
    		rmmod nouveau
    		lsmod | grep -i nouveau
    		modprobe nvidia-drm
    		mv xorg /etc/X11/xorg.conf
    		nvidia-xconfig --query-gpu-info | grep 'BusID : ' | cut -d ' ' -f6
		mv display_setup /etc/lightdm/display_setup.sh
		chmod +x /etc/lightdm/display_setup.sh
		echo " If You Can See Only PCI Value Then Do This:"
		echo "Edit PCI value Accordingly before You proceed -->>> Edit /etc/X11/xorg.conf and add your system PCI value"
		echo "---------------------------------------------------------------------------------------------------------"
		echo "Edit and Add Following: /etc/lightdm/lightdm.conf"
		echo "Add This At ->> [Seat:*] ... display-setup-script=/etc/lightdm/display_setup.sh"
		echo "---------------------------------------------------------------------------------------------------------"
	else
		clear
    		echo "Run This Command Before you proceed : systemctl stop lightdm "
	fi
}

function lightdm-manjaro(){
	whiptail --title "Attention Required" --msgbox "Do uninstall and remove Old Nvidia Driver Packages and Settings" 8 78
	if(whiptail --title "Are You Ready to proceed?" --yesno "If You are Ready to proceed then press YES else NO" 8 78); then
		mhwd -i pci video-nvidia-440xx
		mkdir /etc/pacman.d/hooks
		mv nvidia.hook /etc/pacman.d/hooks
		whiptail --title "Change Required" --msgbox " Remove auto generated nvidia Configuration file -->> Remove From /etc/modprobe.d/ and /etc/X11/xorg.conf.d/" 8 78
		mv optimus.conf /etc/X11/xorg.conf.d/optimus.conf
		mv blacklist-nouveau /etc/modprobe.d/nvidia.conf
		mv nvidia-drm.conf /etc/modprobe.d/nvidia-drm.conf
		mv display_setup /etc/lightdm/display_setup.sh
		chmod +x /etc/lightdm/display_setup.sh
		echo " If You Can See Only PCI Value Then Do This:"
		echo "Edit PCI value Accordingly before You proceed -->>> Edit /etc/X11/xorg.conf and add your system PCI value"
		echo "---------------------------------------------------------------------------------------------------------"
		echo "Edit and Add Following: /etc/lightdm/lightdm.conf"
		echo "Add This At ->> [Seat:*] ... display-setup-script=/etc/lightdm/display_setup.sh"
		echo "---------------------------------------------------------------------------------------------------------"

		whiptail --title "Change Required" --msgbox "Edit PCI value Accordingly before You proceed -->>> Edit /usr/local/bin/optimus.sh and add PCI value" 8 78
	else
		clear
		whiptail --title "Do It then run again" --msgbox "Remove all Previously Installed Nvidia Stuff" 8 78
	fi
}

function sddm-arch(){
	whiptail --title "Attention Required" --msgbox "Do uninstall and remove Old Nvidia Driver Packages and Settings" 8 78
	if(whiptail --title "Are You Ready to proceed?" --yesno "If You are Ready to proceed then press YES else NO" 8 78); then
		pacman -S nvidia nvidia-dkms nvidia-settings
		mkdir /etc/pacman.d/hooks
		mv nvidia.hook /etc/pacman.d/hooks
		mv optimus.conf /etc/X11/xorg.conf.d/optimus.conf
		whiptail --title "Change Required" --msgbox " Remove auto generated nvidia Configuration file -->> Remove From /etc/modprobe.d/ and /etc/X11/xorg.conf.d/" 8 78
		mv blacklist-nouveau /etc/modprobe.d/nvidia.conf
		mv nvidia-drm.conf /etc/modprobe.d/nvidia-drm.conf
		whiptail --title "Change Required" --msgbox "Edit This File /usr/share/sddm/scripts/Xsetup  ... Add as shown in next dialogbox" 8 78
        	whiptail --title "Add This " --msgbox "xrandr --setprovideroutputsource modesetting NVIDIA-0
        	xrandr --auto " 8 78
		whiptail --title "Change Required" --msgbox "Edit PCI value Accordingly before You proceed -->>> Edit /usr/local/bin/optimus.sh and add your PCI value" 8 78
	else
		clear
		whiptail --title "Do It then run again" --msgbox "Remove all Previously Installed Nvidia Stuff" 8 78
	fi
}

function sddm-debian(){
	whiptail --title "Warning" --msgbox "Before Running this script Logout And Press Ctrl+Alt+F2 and run : systemctl stop sddm" 8 78
	whiptail --title "Attention" --msgbox "After Running systemctl stop sddm. Got Black Screen Just Press Ctrl+Alt+F2 For Logout Just Login Then Run This Script.... " 8 78
	if (whiptail --title "Is SDDM Stopped?" --yesno "If SDDM is Stopped then press YES else NO" 8 78); then
    		apt install linux-headers-$(uname -r) nvidia-settings nvidia-driver nvidia-xconfig -Vy
		mv nouveau /etc/modprobe.d/nvidia-blacklists-nouveau.conf
		update-initramfs -u
		clear
		rmmod nouveau
		lsmod | grep -i nouveau
		modprobe nvidia-drm
		mv xorg /etc/X11/xorg.conf
		nvidia-xconfig --query-gpu-info | grep 'BusID : ' | cut -d ' ' -f6
		echo " If You Can See Only PCI Value Then Do This:"
		echo "Edit PCI value Accordingly before You proceed -->>> Edit /etc/X11/xorg.conf and add your system PCI value"
		echo "---------------------------------------------------------------------------------------------------------"
		echo "Edit This File /usr/share/sddm/scripts/Xsetup ..... Add This ->>"
		echo "xrandr --setprovideroutputsource modesetting NVIDIA-0"
		echo "xrandr --auto"
		echo "---------------------------------------------------------------------------------------------------------"
	else
		clear
    		echo "Run This Command Before you proceed : systemctl stop sddm "
	fi
}

function sddm-manjaro(){
	whiptail --title "Attention Required" --msgbox "Do uninstall and remove Old Nvidia Driver Packages and Settings" 8 78
	if(whiptail --title "Are You Ready to proceed?" --yesno "If You are Ready to proceed then press YES else NO" 8 78); then
		mhwd -i pci video-nvidia-440xx
		mkdir /etc/pacman.d/hooks
		mv nvidia.hook /etc/pacman.d/hooks
		mv optimus.conf /etc/X11/xorg.conf.d/optimus.conf
		whiptail --title "Change Required" --msgbox " Remove auto generated nvidia Configuration file -->> Remove From /etc/modprobe.d/ and /etc/X11/xorg.conf.d/" 8 78
		mv blacklist-nouveau /etc/modprobe.d/nvidia.conf
		mv nvidia-drm.conf /etc/modprobe.d/nvidia-drm.conf
		whiptail --title "Change Required" --msgbox "Edit This File /usr/share/sddm/scripts/Xsetup  ... Add as shown in next dialogbox" 8 78
        	whiptail --title "Add This " --msgbox "xrandr --setprovideroutputsource modesetting NVIDIA-0
        	xrandr --auto " 8 78
		whiptail --title "Change Required" --msgbox "Edit PCI value Accordingly before You proceed -->>> Edit /usr/local/bin/optimus.sh and add your PCI value" 8 78
	else
		clear
		whiptail --title "Do It then run again" --msgbox "Remove all Previously Installed Nvidia Stuff" 8 78
	fi
}

function nvidia(){
	clear
	menu
	while [ opt != '' ]
	do
		if [[ $opt = "" ]]; then
			exit;
		else
			case $opt in
				1) clear;
					gdm-arch;
					exit;
					;;
				2) clear;
					gdm-debian;
					exit;
					;;
				3) clear;
					gdm-manjaro;
					exit;
					;;
				4) clear;
					lightdm-arch;
					exit;
					;;
				5) clear;
					lightdm-debian;
					exit;
					;;
				6) clear;
					lightdm-manjaro;
					exit;
					;;
				7) clear;
					sddm-arch;
					exit;
					;;
				8) clear;
					sddm-debian;
					exit;
					;;
				9) clear;
					sddm-manjaro;
					exit;
					;;
				x) clear;
					;;
				q) clear;
					;;
				\n) clear;
					;;
				*) clear;
					menu;
					;;
			esac
		fi
	done
}

if [ `whoami` == "root" ]; then
	nvidia;
else
	echo " You're in LINUX Not Windows... Do Run With ROOT Priviledge "
fi
