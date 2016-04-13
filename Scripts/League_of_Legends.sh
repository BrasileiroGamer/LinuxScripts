#!/usr/bin/env playonlinux-bash

[ "$PLAYONLINUX" = "" ] && exit 0
source "$PLAYONLINUX/lib/sources"
WHOAMI="BrasileiroGamer"

#==================================================================================================#

PROGRAM_AUTHOR="Riot Games"
PROGRAM_TITLE="League of Legends"
PROGRAM_SITE="http://www.riotgames.com"

#==================================================================================================#

WINE_ARCH="x86"
WINE_VERSION="System"
WINE_PREFIX="League_of_Legends"

#==================================================================================================#

LOL_DOWNLOAD_BIN="LeagueOfLegendsBaseNA.exe"
LOL_DOWNLOAD_MD5="9d44b68bd02d7b5426556f64d86bbd16"
LOL_DOWNLOAD_URL="http://l3cdn.riotgames.com/Installer/SingleFileInstall/LeagueOfLegendsBaseNA.exe"
LOL_BIN_FILE="lol.launcher.admin.exe"
LOL_DESKTOP_CATEGORY="Game;"

#==================================================================================================#

TUXLOL_DOWNLOAD_FOLDER="tuxlol-0.1-dd62ba8-bin/"
TUXLOL_DOWNLOAD_TAR="tuxlol-0.1-dd62ba8-bin.tar.gz"
TUXLOL_DOWNLOAD_MD5="1a3fa2be366d90ab05d548422e6dc701"
TUXLOL_DOWNLOAD_URL="https://bitbucket.org/Xargoth/tuxlol/downloads/tuxlol-0.1-dd62ba8-bin.tar.gz"
TUXLOL_BIN_FILE="tuxlol.exe"
TUXLOL_BIN_TARGET='"../Riot Games/League of Legends"'
TUXLOL_BIN_PATH="$HOME/.PlayOnLinux/wineprefix/$WINE_PREFIX/drive_c/TuxLoL"
TUXLOL_BIN_SCRIPT="$HOME/.PlayOnLinux/wineprefix/$WINE_PREFIX/drive_c/TuxLoL/TuxLoL.sh"
TUXLOL_DESKTOP_CATEGORY="Game;"
TUXLOL_DESKTOP_FILE="$HOME/.local/share/applications/TuxLoL.desktop"

#==================================================================================================#




# void main()
	
	# Main Window
	POL_SetupWindow_Init
	POL_SetupWindow_presentation "$PROGRAM_TITLE" "$PROGRAM_AUTHOR" "$PROGRAM_SITE" "$WHOAMI" "$WINE_PREFIX"

	# Version Check
	POL_RequiredVersion 4.0.18 || POL_Debug_Fatal "$PROGRAM_TITLE won't work with $APPLICATION_TITLE $VERSION\nPlease update PlayOnLinux."

	# Mono Check
	which mono || POL_Debug_Fatal "$PROGRAM_TITLE needs the 'mono' package is installed to run the TuxLoL.\n\nTuxLoL scans the League of Legends data files for DDS textures with mipmaps and removes them.\nThis is needed to store inside the game to work properly.\n\nPlease install 'mono' package."

	# Zenity Check
	which zenity || POL_Debug_Fatal "TuxLoL needs the 'zenity' package is installed to run the properly.\n\nPlease install 'zenity' package."

	# Setting WineArch
	POL_System_SetArch "$WINE_ARCH"

	# Selecting WinePrefix
	POL_Wine_SelectPrefix "$WINE_PREFIX"

	# Creating WinePrefix
	POL_Wine_PrefixCreate

	# Installing Depends
	POL_Call POL_Install_vcrun2005
	POL_Call POL_Install_vcrun2008
	POL_Call POL_Install_d3dx9
	POL_Call POL_Install_DisableCrashDialog
	POL_Call POL_Install_FontsSmoothRGB

	# Creating TempDir
	POL_System_TmpCreate "$WINE_PREFIX"

	# Entering TempDir
	cd "$POL_System_TmpDir"

	# Downloading League Of Legends
	POL_Download "$LOL_DOWNLOAD_URL" "$LOL_DOWNLOAD_MD5"

	# Installing League Of Legends
	POL_Wine_WaitBefore "$PROGRAM_TITLE"
	POL_Wine "$POL_System_TmpDir/$LOL_DOWNLOAD_BIN"

	# Override 'dnsapi'
	POL_Wine_OverrideDLL "builtin,native" "dnsapi"

	# GPU Config
	POL_Wine_SetVideoDriver

	# Creating Shortcuts
	POL_Shortcut "$LOL_BIN_FILE" "$PROGRAM_TITLE" "" "" "$LOL_DESKTOP_CATEGORY"

	# Entering TempDir
	cd "$POL_System_TmpDir"

	# Downloading TuxLoL
	POL_Download "$TUXLOL_DOWNLOAD_URL" "$TUXLOL_DOWNLOAD_MD5"

	# Extracting .tar.gz
	tar -zxvf "$TUXLOL_DOWNLOAD_TAR"

	# Moving Directory
	mv "$TUXLOL_DOWNLOAD_FOLDER" "$TUXLOL_BIN_PATH"

	# Creating Script
	echo '#!/bin/bash'																						>  "$TUXLOL_BIN_SCRIPT"
	echo																									>> "$TUXLOL_BIN_SCRIPT"
	echo 'if zenity --question --title="TuxLoL Patcher" --text="You want to run TuxLoL Patcher now?"; then' >> "$TUXLOL_BIN_SCRIPT"
	echo '('																								>> "$TUXLOL_BIN_SCRIPT"
	echo 'echo "# Patching Files"...;'																		>> "$TUXLOL_BIN_SCRIPT"
	echo sleep 2																							>> "$TUXLOL_BIN_SCRIPT"
	echo mono "$TUXLOL_BIN_FILE" patch --dir "$TUXLOL_BIN_TARGET" --no-backup								>> "$TUXLOL_BIN_SCRIPT"
	echo 'echo "# Patching Done!";'																			>> "$TUXLOL_BIN_SCRIPT"
	echo sleep 2																							>> "$TUXLOL_BIN_SCRIPT"
	echo ')| zenity --progress --title="TuxLoL Patcher" --percentage=2 --pulsate --no-cancel'				>> "$TUXLOL_BIN_SCRIPT"
	echo fi																									>> "$TUXLOL_BIN_SCRIPT"
	echo																									>> "$TUXLOL_BIN_SCRIPT"

	# Executable TuxLoL.sh
	chmod +x "$TUXLOL_BIN_SCRIPT"

	# Creating TuxLoL.desktop
	echo [Desktop Entry]						>  "$TUXLOL_DESKTOP_FILE"
	echo Name=TuxLoL Patcher					>> "$TUXLOL_DESKTOP_FILE"
	echo Exec="$TUXLOL_BIN_SCRIPT"				>> "$TUXLOL_DESKTOP_FILE"
	echo StartupNotify=true						>> "$TUXLOL_DESKTOP_FILE"
	echo Terminal=false							>> "$TUXLOL_DESKTOP_FILE"
	echo Type=Application						>> "$TUXLOL_DESKTOP_FILE"
	echo Icon=playonlinux 						>> "$TUXLOL_DESKTOP_FILE"
	echo "Categories=$TUXLOL_DESKTOP_CATEGORY"	>> "$TUXLOL_DESKTOP_FILE"
	echo										>> "$TUXLOL_DESKTOP_FILE"

	# Executable TuxLoL.desktop
	chmod +x "$TUXLOL_DESKTOP_FILE"

	# Exiting Script
	POL_Wine_reboot
	POL_System_TmpDelete

	if [ ! "$(uname -a | grep 'x86-64')" = true ]; then
		POL_SetupWindow_message "It was verified that your system has x86-64 architecture. You may need to install some packages for the game to run properly:\n\nlib32-alsa-lib, lib32-alsa-plugins (audio within the game)\nlib32-pulse (only if you use PulseAudio, you must also install the ALSA packages listed above)\nlib32-gnutls (solves some problems connecting to the game server)\n\nNOTE: The packages described here were over a Archlinux x86_64 multilib distribution, if you are using another distribution, you have to search the equivalent packages." "$PROGRAM_TITLE"
	else
		POL_SetupWindow_message "It was verified that your system has x86 architecture. You may need to install some packages for the game to run properly:\n\nalsa-lib, alsa-plugins (audio within the game)\npulseaudio (only if you use PulseAudio, you must also install the ALSA packages listed above)\ngnutls (solves some problems connecting to the game server)\n\nNOTE: The packages described here were over a Archlinux x86 distribution, if you are using another distribution, you have to search the equivalent packages." "$PROGRAM_TITLE"
	fi

	POL_SetupWindow_message "$PROGRAM_TITLE installation completed successfully!\n\nNOTE: You need to run TuxLoL every time the game update." "$PROGRAM_TITLE"
	POL_SetupWindow_Close
exit
