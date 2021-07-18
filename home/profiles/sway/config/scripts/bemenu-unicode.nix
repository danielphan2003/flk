{ coreutils
, writeShellScript
, libnotify
, ydotool
, sway
, waylandPkgs
, bemenu-run
, unicode-emoji
}:
let inherit (waylandPkgs) wl-clipboard; in
writeShellScript "bemenu-unicode.sh" ''

  # Original from Luke Smith:
  # https://github.com/LukeSmithxyz/voidrice/blob/master/.local/bin/dmenuunicode
  # The famous "get a menu of emojis to copy" script.

  # Get user selection via bemenu from emoji file.
  chosen=$(${coreutils}/bin/cut -d ';' -f1 ${unicode-emoji}/share/unicode/emoji/emoji-data.txt | ${bemenu-run} -l 30)

  # Exit if none chosen.
  [ -z "$chosen" ] && exit
  chosen=$(echo "$chosen" | sed "s/ .*//")

  # If you run this command with an argument, it will automatically insert the
  # character. Otherwise, show a message that the emoji has been copied.
  #
  # ydotool works only passwordless if the user has permissions to write to /dev/uinput
  # https://github.com/ReimuNotMoe/ydotool/bin/ydotool/issues/25
  #
  # sudo usermod -a -G users $USER
  # echo "KERNEL==\"uinput\", GROUP=\"users\", MODE=\"0660\", OPTIONS+=\"static_node=uinput\"" | sudo tee /etc/udev/rules.d/80-uinput.rules > /dev/null
  # reboot

  if [ -x "$(command -v ${ydotool}/bin/ydotool)" ] && [ -n "$1" ] && [ -w "/dev/uinput" ]; then
    echo "$chosen" | ${coreutils}/bin/tr -d '\n' | ${wl-clipboard}/bin/wl-copy

    # Get focused window
    TERMINAL="$(${sway}/bin/swaymsg -r -t get_tree | jq -r '.. | (.nodes? // empty)[] | select(.focused==true) | .app_id')"
    # Check for terminal, to paste differently
    if [ "$TERMINAL" = 'Alacritty' ]; then
      ${ydotool}/bin/ydotool key ctrl+shift+v
    else
      ${ydotool}/bin/ydotool key ctrl+v
    fi
  else
    echo "$chosen" | ${coreutils}/bin/tr -d '\n' | ${wl-clipboard}/bin/wl-copy
    ${libnotify}/bin/notify-send "'$chosen' copied to clipboard." &
  fi
''
