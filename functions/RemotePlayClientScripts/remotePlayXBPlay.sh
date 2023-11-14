#!/bin/bash

# Variables
XBPlay_emuName="XBPlay"
XBPlay_emuType="FlatPak"
XBPlay_emuPath="net.studio08.xbplay"
XBPlay_releaseURL=""

# Install
XBPlay_install() {
	setMSG "Installing $XBPlay_emuName."
	local ID="$XBPlay_emuPath"
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo --user
	flatpak install flathub "$ID" -y --user
	flatpak override "$ID" --filesystem=host --user
	flatpak override "$ID" --share=network --user
	cp "$EMUDECKGIT/tools/remoteplayclients/XBPlay Remote Play Client.sh" "$romsPath/remoteplay"
	chmod +x "$romsPath/remoteplay/XBPlay Remote Play Client.sh"
	XBPlay_addSteamInputProfile
}

# ApplyInitialSettings
XBPlay_init() {
	setMSG "Initializing $XBPlay_emuName settings."
	configEmuFP "$XBPlay_emuName" "$XBPlay_emuPath" "true"
	$XBPlay_addSteamInputProfile
}

# Update flatpak & launcher script
XBPlay_update() {
	setMSG "Updating $XBPlay_emuName settings."
	local ID="$XBPlay_emuPath"
	flatpak update $ID -y --user	
	flatpak override $ID --filesystem=host --user
	flatpak override $ID --share=network --user
	rm "$romsPath/remoteplay/XBPlay Remote Play Client.sh"
	cp "$EMUDECKGIT/tools/remoteplayclients/XBPlay Remote Play Client.sh" "$romsPath/remoteplay"
	chmod +x "$romsPath/remoteplay/XBPlay Remote Play Client.sh"
}

# Uninstall
XBPlay_uninstall() {
	setMSG "Uninstalling $XBPlay_emuName."
    uninstallEmuFP "$XBPlay_emuPath"
	rm "$romsPath/remoteplay/XBPlay Remote Play Client.sh"
}

# Check if installed
XBPlay_IsInstalled() {
	if [ "$(flatpak --columns=app list | grep "$XBPlay_emuPath")" == "$XBPlay_emuPath" ]; then
		echo true
		return 1
	else
		echo false
		return 0
	fi
}

# Import steam profile
XBPlay_addSteamInputProfile() {
	rsync -r "$EMUDECKGIT/configs/steam-input/emudeck_xbplay_controller_config.vdf" "$HOME/.steam/steam/controller_base/templates/"
}
