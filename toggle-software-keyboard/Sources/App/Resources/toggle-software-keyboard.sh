osascript <<EOD
  tell application "Simulator" to activate
  tell application "System Events"
    keystroke "k" using {command down}
  end tell
EOD
