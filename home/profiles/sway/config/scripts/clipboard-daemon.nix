{ writeShellScript, ts, libnotify, waylandPkgs }:
let inherit (waylandPkgs) wl-clipboard clipman; in
writeShellScript "clipboard-daemon.sh" ''

  export XDG_RUNTIME_DIR=/run/user/`id -u`
  export WAYLAND_DISPLAY=wayland-1

  pkill ${wl-clipboard}/bin/wl-paste || ${libnotify}/bin/notify-send "Restarting clipman: already dead" | ${ts}/bin/ts

  exec ${wl-clipboard}/bin/wl-paste -p -t text --watch ${clipman}/bin/clipman store -P 2>&1 | ${ts}/bin/ts > ~/.local/share/clipman.log
''
