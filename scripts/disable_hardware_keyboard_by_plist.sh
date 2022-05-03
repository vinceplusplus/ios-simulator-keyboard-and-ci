#!/bin/bash

# example: ./disable_hardware_keyboard_by_plist.sh "iPhone 13"

# inspired here, https://stackoverflow.com/questions/38010494/is-it-possible-to-toggle-software-keyboard-via-the-code-in-ui-test

# shutdown everything
xcrun simctl shutdown all
killall "Simulator"

sleep 1

# desired device type, cater to only filter by device type
device_type=$1

# grab the first eligible UDID
filtered_line=$(xcrun simctl list devices | grep "${device_type} (" | head -1)
echo "> from: ${filtered_line}"
udid=$(echo "$filtered_line" | grep -E -o ".{8}-.{4}-.{4}-.{4}-.{12}")
echo "> chosen UDID: ${udid}"

domain="com.apple.iphonesimulator"

# flush cache
defaults read $domain > /dev/null

eval plist_file_path=~/Library/Preferences/${domain}.plist
echo "> plist file path: ${plist_file_path}"

# try to add (will create file if necessary). if not, replace (need entry already there)
/usr/libexec/PlistBuddy -c "add :DevicePreferences:${udid}:ConnectHardwareKeyboard bool false" ${plist_file_path} \
|| /usr/libexec/PlistBuddy -c "set :DevicePreferences:${udid}:ConnectHardwareKeyboard false" ${plist_file_path}

defaults read $domain > /dev/null

xcrun simctl boot "${udid}"
open -a Simulator.app

echo "> completed"
