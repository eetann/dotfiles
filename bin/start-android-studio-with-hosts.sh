#!/usr/bin/env bash
#ref: https://codeberg.org/blizzz/launch-android-studio-with-hosts/src/branch/main/start-android-with-hosts.sh
# AVD=$1

# echo "Starting emulator with writable system"
# emulator -avd "${AVD}" -writable-system 1>/dev/null &
# sleep 5

# TODO: fzfを使って選べるようにする
# デバイスIDを引数から取得
DEVICE_ID=$1

# デバイスIDが指定されているか確認
if [ -z "$DEVICE_ID" ]; then
    echo "Usage: $0 <device-id>"
    exit 1
fi

echo "Setting ADB to root mode for device $DEVICE_ID"
adb -s "$DEVICE_ID" root

echo "Disabling verification on device $DEVICE_ID"
adb -s "$DEVICE_ID" disable-verity

echo "Rebooting device $DEVICE_ID"
adb -s "$DEVICE_ID" reboot

echo "Waiting for the device $DEVICE_ID"
until adb -s "$DEVICE_ID" shell whoami; do
	sleep 2
done

echo "Setting ADB to root mode for device $DEVICE_ID"
adb -s "$DEVICE_ID" root

echo "Remounting on device $DEVICE_ID"
adb -s "$DEVICE_ID" remount

echo "Pushing our hosts file to device $DEVICE_ID"
adb -s "$DEVICE_ID" push /etc/hosts /etc/hosts

echo "Done"
