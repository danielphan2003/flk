{ lib
, coreutils
, writeShellScript
, feh
, procps
, util-linux
, libnotify
, pywalfox
, pywal
, sway
, paper
, waylandPkgs
, backgroundDir
, colors
}:
let
  inherit (waylandPkgs) swaybg;
  inherit (lib.our.mkCustomI3Rule) colorSetStr;

  clientColors = lib.concatStringsSep " ; " [
    "client.focused ${colorSetStr colors.focused}"
    "client.focused_inactive ${colorSetStr colors.focusedInactive}"
    "client.unfocused ${colorSetStr colors.unfocused}"
    "client.urgent ${colorSetStr colors.urgent}"
    "client.placeholder ${colorSetStr colors.placeholder}"
    "client.background ${colors.background}"
  ];
in
writeShellScript "wal-set.sh" ''
  export swaySocket=''${XDG_RUNTIME_DIR:-/run/user/$UID}/sway-ipc.$UID.$(${procps}/bin/pgrep -x sway || ${coreutils}/bin/true).sock

  export DISPLAY=:0

  ${pywal}/bin/wal -i "${backgroundDir}" -stneq

  . $HOME/.cache/wal/colors.sh

  [ ! -S $swaySocket ] && ${feh}/bin/feh --bg-fill $(< $HOME/.cache/wal/wal) && exit

  PID=$(${procps}/bin/pgrep paper)

  # guarantees to run within cron jobs
  ${sway}/bin/swaymsg -s $swaySocket "exec ${paper}/bin/paper -i '$wallpaper'"

  ${coreutils}/bin/sleep 0.2

  ${pywalfox}/bin/pywalfox update &

  ${libnotify}/bin/notify-send "Applying theme for sway ⚡" &

  ${sway}/bin/swaymsg -s $swaySocket "${clientColors}" &

  ${util-linux}/bin/kill -USR2 $(${procps}/bin/pgrep waybar) &

  ${util-linux}/bin/kill $PID
''
