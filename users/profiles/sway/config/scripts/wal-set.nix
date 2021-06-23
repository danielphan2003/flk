{ lib, coreutils, bash, writeScript
, feh, procps, libnotify
, pywalfox, pywal, sway, util-linux
, backgroundDir, colors
}:
let
  inherit (lib.our.mkCustomI3Rule) colorSetStr;

  clientColors = lib.concatStringsSep " ; " [
    "client.focused ${colorSetStr colors.focused}"
    "client.focused_inactive ${colorSetStr colors.focusedInactive}"
    "client.unfocused ${colorSetStr colors.unfocused}"
    "client.urgent ${colorSetStr colors.urgent}"
    "client.placeholder ${colorSetStr colors.placeholder}"
    "client.background ${colors.background}"
  ];
in writeScript "wal-set.sh" ''
  #!/usr/bin/env ${bash}/bin/bash
  export swaySocket=''${XDG_RUNTIME_DIR:-/run/user/$UID}/sway-ipc.$UID.$(${procps}/bin/pgrep -x sway || ${coreutils}/bin/true).sock
  export DISPLAY=:0

  ${pywal}/bin/wal -i "${backgroundDir}" -stne
  . $HOME/.cache/wal/colors.sh

  [ ! -S $swaySocket ] &&
    ${feh}/bin/feh --bg-fill $(< $HOME/.cache/wal/wal) && exit

  ${libnotify}/bin/notify-send "Applying theme for sway ⚡" &

  ${pywalfox}/bin/pywalfox update &

  ${util-linux}/bin/kill -USR2 $(${procps}/bin/pgrep waybar)

  ${sway}/bin/swaymsg \
    -s $swaySocket \
    "${clientColors} ; output \"*\" background \"$wallpaper\" fill"
''