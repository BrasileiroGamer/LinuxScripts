#!/bin/bash

GAME_WND="$1" # Window Mode. Passed by user argument.
GAME_APP="$2" # Game Location. Passed by user argument, full path + .exe file.
GAME_APP_BASENAME="$(basename "$GAME_APP")" # GAME_APP basename. Don't change this.

STEAM_APP="/home/lucas/Games/Steam/Steam.exe" # Steam.exe Location. Change to your Steam.exe location.
STEAM_FRIENDS_TAB="Amigos" # Change according to the Steam localization (eg: STEAM_FRIENDS_TAB="Amigos" in pt_BR).
STEAM_APP_BASENAME="$(basename "$STEAM_APP")" # STEAM_APP basename. Don't change this.
STEAM_APP_PARAMETERS="-no-cef-sandbox" # Steam Execution Parameters. Change or add if you need.


DESKTOP_REFRESH="75" # Resolution Refresh Rate (Hz). Change to your current default refresh rate.
DESKTOP_RESOLUTION="$(xdpyinfo | grep "dimensions" | awk '{print $2}')" # Default Resolution. Virtually all distributions have the 'xdpyinfo' installed by default.
DESKTOP_RESOLUTION_SCRIPT="nvidia-settings --assign CurrentMetaMode="$DESKTOP_RESOLUTION"_"$DESKTOP_REFRESH"" # Resolution Restore Script (NVIDIA). Change if you need.


# All options supports additional Steam parameters.
# You can call the script at startup files (shortcuts).

# Help
if [ "$GAME_WND" == "--help" ]; then
	printf "\n WineSteam Application Launcher v2016.1\n\n"
	printf " winesteam-launcher --help                                                This help.\n"
	printf " winesteam-launcher --nativewindow [path_to_game.exe] [parameters]        Native windowed mode.\n"
	printf " winesteam-launcher --virtualwindow [path_to_game.exe] [parameters]       Virtual windowed mode.\n"
	printf " winesteam-launcher --nativefullscreen [path_to_game.exe] [parameters]    Native fullscreen mode.\n\n"
	exit 0
fi


# Window Mode Verification
if ! [[ "$GAME_WND" == "--nativefullscreen" || "$GAME_WND" == "--nativewindow" || "$GAME_WND" == "--virtualwindow" ]]; then
	printf "\n Usage: winesteam-launcher [windowmode] [game.exe] [parameters]\n\n"
	exit 1
fi


# Game Verification
if [ -z $(printf "$GAME_APP_BASENAME" | grep ".exe") ]; then
	printf "\n Usage: winesteam-launcher [windowmode] [game.exe] [parameters]\n\n"
	exit 1
fi



# Open Steam if is not running
if [ $(pidof "$STEAM_APP_BASENAME" | wc -w) == 0 ]; then
	exec wine "$STEAM_APP" "$STEAM_APP_PARAMETERS"

	while [ -z $(xwininfo -children -root -tree | grep "$STEAM_APP_BASENAME" | grep "$STEAM_FRIENDS_TAB" | awk '{print $1}') ]; do
		sleep 2
	done;
fi


# Native Fullscreen Mode
# Runs the game in his native fullscreen mode and after run, back to the default resolution of system.
# The advantage is that automagically the resolution back to normal after the execution , but on the other hand can cause problems with some games.
# Not recommended, prefer to -virtual or -nativewindow modes. Use only if you are in desperate need this.
if [ "$GAME_WND" == "--nativefullscreen" ]; then
	# Stores the current default resolution
	printf "$DESKTOP_RESOLUTION_SCRIPT" > /tmp/winesteam-launcher
	DESKTOP_DEFAULT_RESOLUTION=`cat /tmp/winesteam-launcher`

	# Execute the game
	wine "$GAME_APP" "-steam" "$@"

	# Restores desktop resolution
	"$DESKTOP_DEFAULT_RESOLUTION"
fi


# Native Windowed Mode
# Many games have this option.
# Recommended for native windowed parameters or native in-game options.
if [ "$GAME_WND" == "--nativewindow" ]; then
	# Execute the game
	exec wine "$GAME_APP" "-steam" "$@"
fi


# Virtual Window Mode
# Execute the game on a wine virtual desktop with size of a current system resolution.
# The window automagically resize for the resolution of game.
# If the game is in the native resolution of the system , it will run on a "fake fullscreen".
# Recommended to avoid fullscreen issues.
if [ "$GAME_WND" == "--virtualwindow" ]; then
	# Execute the game
	exec wine explorer /desktop="$GAME_APP_BASENAME","$DESKTOP_RESOLUTION" "$GAME_APP" "-steam" "$@"
fi

exit 0
