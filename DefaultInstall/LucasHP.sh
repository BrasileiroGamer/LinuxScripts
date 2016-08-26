#!/bin/bash

# Antergos MATE Desktop

WINE_INSTALLER="$1"

ClearCache()
{
	sudo bash -c "echo 's' | sudo pacman -Scc >/dev/null 2>&1"
	clear
	history -c
}

WineInstaller()
{
	sudo pacman -S lib32-alsa-lib lib32-alsa-plugins lib32-giflib lib32-gnutls lib32-gst-plugins-base-libs lib32-gtk3 lib32-harfbuzz lib32-libcl lib32-libldap lib32-libpulse lib32-libva lib32-libxcomposite lib32-libxinerama lib32-libxslt lib32-mpg123 lib32-openal lib32-v4l-utils openal wine-mono wine-staging winetricks wine_gecko --noconfirm
	ClearCache

	echo "WINEARCH=win32" >> ~/.bashrc
	echo "WINEDEBUG=-all" >> ~/.bashrc
	echo "WINEDLLOVERRIDES=winemenubuilder.exe=d" >> ~/.bashrc
}

sudo bash -c "echo lucas ALL = NOPASSWD:ALL > /etc/sudoers.d/lucas"

sudo pacman -Rscn pidgin pluma pragha totem totem-plparser xfburn --noconfirm && ClearCache

sudo pacman -Syu --noconfirm && ClearCache

sudo pacman -S gcc-multilib gcc-libs-multilib gdb && ClearCache

yaourt -S aur/ttf-ms-fonts --noconfirm && ClearCache

yaourt -S aur/ttf-tahoma --noconfirm && ClearCache

sudo pacman -S p7zip chromium-pepper-flash leafpad dnsmasq --noconfirm && ClearCache

yaourt -S aur/sublime-text-dev --noconfirm && ClearCache

yaourt -G aur/wps-office && cd wps-office/ && makepkg -Acs --noconfirm && sudo pacman -U wps-office-10.1.0.5672_a21-1-x86_64.pkg.tar --noconfirm && ClearCache

yaourt -S aur/ttf-wps-fonts --noconfirm && ClearCache

yaourt -S aur/wps-office-extension-portuguese-brazilian-dictionary --noconfirm && ClearCache

sudo pacman -S vlc qt4 gparted id3v2 easytag bleachbit --noconfirm && ClearCache

yaourt -S jdk && ClearCache

sudo pacman -S mono --noconfirm && ClearCache

sudo pacman -S netbeans --noconfirm && ClearCache

sudo pacman -S monodevelop --noconfirm && ClearCache

sudo sed -i 's/dns=default/dns=dnsmasq/g' /etc/NetworkManager/NetworkManager.conf

if [ "$WINE_INSTALLER" == "--wine" ]; then
	WineInstaller
fi

sudo bash -c "echo lucas ALL = NOPASSWD: /usr/bin/nano > /etc/sudoers.d/lucas"
sudo bash -c "echo lucas ALL = NOPASSWD: /usr/bin/pacman >> /etc/sudoers.d/lucas"
sudo bash -c "echo lucas ALL = NOPASSWD: /usr/bin/e4defrag >> /etc/sudoers.d/lucas"
sudo bash -c "echo lucas ALL = NOPASSWD: /usr/bin/bleachbit >> /etc/sudoers.d/lucas"
