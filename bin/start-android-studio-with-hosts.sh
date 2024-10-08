#!/usr/bin/env bash
#ref: https://codeberg.org/blizzz/launch-android-studio-with-hosts/src/branch/main/start-android-with-hosts.sh
# AVD=$1

# echo "Starting emulator with writable system"
# emulator -avd "${AVD}" -writable-system 1>/dev/null &
# sleep 5

echo "Setting ADB to root mode"
adb root

echo "Disabling verification"
adb disable-verity

echo "Rebooting emulator"
adb reboot

echo "Waiting for the emulator"
until adb shell whoami; do
	sleep 2
done

echo "Setting ADB to root mode"
adb root

echo "Remounting"
adb remount

echo "Pushing our hosts file"
adb push /etc/hosts etc/hosts

echo "Done"
