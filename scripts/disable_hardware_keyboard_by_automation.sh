#!/bin/bash

# example: ./disable_hardware_keyboard_by_automation.sh "iPhone 13"

# inspired here, https://stackoverflow.com/questions/38010494/is-it-possible-to-toggle-software-keyboard-via-the-code-in-ui-test

device_type=$1

filtered_line=$(xcrun simctl list devices | grep "${device_type} (" | head -1)
echo "> from: ${filtered_line}"
udid=$(echo "$filtered_line" | grep -E -o ".{8}-.{4}-.{4}-.{4}-.{12}")
echo "> chosen UDID: ${udid}"

xcrun simctl boot "${udid}"
open -a Simulator.app

echo "> wait for the simulator to launch"

sleep 5

domain="com.apple.iphonesimulator"

# flush cache
defaults read $domain > /dev/null

eval plist_file_path=~/Library/Preferences/${domain}.plist
echo "> plist file path: ${plist_file_path}"

is_hardware_keyboard_connected=$(/usr/libexec/PlistBuddy -c "print DevicePreferences:${udid}:ConnectHardwareKeyboard" ${plist_file_path})
echo "> is_hardware_keyboard_connected: ${is_hardware_keyboard_connected}"

if [ "$is_hardware_keyboard_connected" != "false" ]; then
  echo "> will uncheck hardware keyboard"
osascript <<EOD
  tell application "Simulator" to activate
  tell application "System Events"
      keystroke "K" using {command down, shift down}
  end tell
EOD

  sleep 1

  echo "> verify..."

  defaults read $domain > /dev/null

  is_hardware_keyboard_connected=$(/usr/libexec/PlistBuddy -c "print DevicePreferences:${udid}:ConnectHardwareKeyboard" ${plist_file_path})
  echo "> is_hardware_keyboard_connected: ${is_hardware_keyboard_connected}"
fi

echo "> completed"
