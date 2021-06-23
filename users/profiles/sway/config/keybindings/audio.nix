{ pkgs, mod, ... }:
let
  pamixer = "${pkgs.pamixer}/bin/pamixer";
  playerctl = "${pkgs.playerctl}/bin/playerctl";

  volnoti = pkgs.callPackage ../scripts/volnoti.nix { };

  # FIXME: not working
  notify-volume = ''${volnoti}'';
  # exec ${pkgs.libnotify}/bin/notify-send "Volume ${action}" "$(${pkgs.gawk}/bin/awk -F"[][]" '/Left:/ { print $2 }' <(${pkgs.alsaUtils}/bin/amixer sget Master))"

  # adjust volume on default sink
  volume = cmd: ''exec ${pamixer} ${cmd}; ${notify-volume}'';
  # ${notify-volume (if cmd == "+2%" then "increased" else "decreased")}

  # control media with playerctl
  media = cmd: "exec ${playerctl} ${cmd}";
in
{
  # Control volume
  XF86AudioRaiseVolume = volume "-i 2";
  "${mod}+Alt+Up" = volume "-i 2";

  XF86AudioLowerVolume = volume "-d 2";
  "${mod}+Alt+Down" = volume "-d 2";

  XF86AudioMute = volume "-m";
  XF86AudioMicMute = volume "-m";

  # Control media
  XF86AudioPlay = media "play";
  XF86AudioPause = media "pause";
  "${mod}+Alt+Space" = media "play-pause";

  XF86AudioNext = media "next";
  "${mod}+Alt+Right" = media "next";

  XF86AudioPrev = media "previous";
  "${mod}+Alt+Left" = media "previous";
}
