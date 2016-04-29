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
WINE_VMS="1024"
WINE_PREFIX="League_of_Legends"
WINE_VERSION="1.9.8-staging" # Arch Linux Current

#==================================================================================================#

LOL_DOWNLOAD_BIN="LeagueOfLegendsBaseNA.exe"
LOL_DOWNLOAD_MD5="9d44b68bd02d7b5426556f64d86bbd16"
LOL_DOWNLOAD_URL="http://l3cdn.riotgames.com/Installer/SingleFileInstall/LeagueOfLegendsBaseNA.exe"
LOL_BIN_FILE="lol.launcher.admin.exe"
LOL_DESKTOP_CATEGORY="Game;"

#==================================================================================================#




# void main()
	
	# Main Window
	POL_SetupWindow_Init
	POL_SetupWindow_presentation "$PROGRAM_TITLE" "$PROGRAM_AUTHOR" "$PROGRAM_SITE" "$WHOAMI" "$WINE_PREFIX"

	# Version Check
	POL_RequiredVersion 4.0.18 || POL_Debug_Fatal "$PROGRAM_TITLE won't work with $APPLICATION_TITLE $VERSION\nPlease update PlayOnLinux."

	# Setting WineArch
	POL_System_SetArch "$WINE_ARCH"

	# Selecting WinePrefix
	POL_Wine_SelectPrefix "$WINE_PREFIX"

	# Creating WinePrefix
	POL_Wine_PrefixCreate

	# Installing Depends
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

	# GPU VMS
	POL_SetupWindow_VMS "$WINE_VMS"

	# Creating Shortcuts
	POL_Shortcut "$LOL_BIN_FILE" "$PROGRAM_TITLE" "" "" "$LOL_DESKTOP_CATEGORY"

	# Exiting Script
	POL_Wine_reboot
	POL_System_TmpDelete

	POL_SetupWindow_message "$PROGRAM_TITLE installation completed successfully!" "$PROGRAM_TITLE"
	POL_SetupWindow_Close
exit
