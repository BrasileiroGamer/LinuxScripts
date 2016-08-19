#!/usr/bin/env playonlinux-bash

[ "$PLAYONLINUX" = "" ] && exit 0
source "$PLAYONLINUX/lib/sources"
WHOAMI="BrasileiroGamer"

#==================================================================================================#

PROGRAM_AUTHOR="Microsoft"
PROGRAM_TITLE="Microsoft Office 2010"
PROGRAM_SITE="http://www.microsoft.com"

#==================================================================================================#

WINE_ARCH="x86"
WINE_VERSION="https://www.archlinux.org/packages/multilib/x86_64/wine-staging" #Arch Linux Current (System). If you user other distro, verify if is the latest version of wine-staging on PlayOnLinux. If not, change this version to latest of your have on PlayOnLinux.
WINE_PREFIX="Microsoft_Office_2010"

#==================================================================================================#

MSO_CATEGORY="Office;"

#==================================================================================================#




# void main()
	
	# Main Window
	POL_SetupWindow_Init
	POL_SetupWindow_presentation "$PROGRAM_TITLE" "$PROGRAM_AUTHOR" "$PROGRAM_SITE" "$WHOAMI" "$WINE_PREFIX"

	# Version Check
	POL_RequiredVersion 4.0.18 || POL_Debug_Fatal "$PROGRAM_TITLE won't work with $APPLICATION_TITLE $VERSION\nPlease update PlayOnLinux."

	# Installer Check
	POL_SetupWindow_browse "Please select the installer:" "$PROGRAM_TITLE"

	if [ ! "$(file $APP_ANSWER | grep 'x86-64')" = "" ]; then
		POL_Debug_Fatal "$PROGRAM_TITLE is not supported in x64 version.\nPlease use a x86 version of $PROGRAM_TITLE."
	fi

	# Setting WineArch
	POL_System_SetArch "$WINE_ARCH"

	# Selecting WinePrefix
	POL_Wine_SelectPrefix "$WINE_PREFIX"

	# Creating WinePrefix
	POL_Wine_PrefixCreate #Change this line to 'POL_Wine_PrefixCreate "$WINE_VERSION"' if you use other distro or not have the wine-staging installed in your system.

	# Installing Depends
	POL_Call POL_Install_msxml6
	POL_Call POL_Install_DisableCrashDialog
	POL_Call POL_Install_FontsSmoothRGB

	# Installing Microsoft Office 2010
	POL_Wine_WaitBefore "$PROGRAM_TITLE"
	POL_Wine "$APP_ANSWER"

	# Override 'riched20'
	POL_Wine_OverrideDLL "native,builtin" "riched20"

	# Creating Shortcuts
	POL_Shortcut "winword.exe" "Microsoft Word 2010" "" "" "$MSO_CATEGORY"
	POL_Shortcut "excel.exe" "Microsoft Excel 2010" "" "" "$MSO_CATEGORY"
	POL_Shortcut "powerpnt.exe" "Microsoft Powerpoint 2010" "" "" "$MSO_CATEGORY"

	# Writing Extensions
	POL_Extension_Write doc "Microsoft Word 2010"
	POL_Extension_Write docx "Microsoft Word 2010"
	POL_Extension_Write xls "Microsoft Excel 2010"
	POL_Extension_Write xlsx "Microsoft Excel 2010"
	POL_Extension_Write ppt "Microsoft Powerpoint 2010"
	POL_Extension_Write pptx "Microsoft Powerpoint 2010"

	# Exiting Script
	POL_Wine_reboot
	POL_SetupWindow_message "$PROGRAM_TITLE installation completed successfully!" "$PROGRAM_TITLE"
	POL_SetupWindow_Close
exit
