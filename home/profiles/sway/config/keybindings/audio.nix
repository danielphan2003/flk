{ pkgs, mod, ... }:
let
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  volumectl = "${pkgs.avizo}/bin/volumectl";

  volume = cmd: "exec ${volumectl} ${cmd}";
  media = cmd: "exec ${playerctl} ${cmd}";
in
{
  # Control volume
  XF86AudioRaiseVolume = volume "+";
  "${mod}+Alt+Up" = volume "+";

  XF86AudioLowerVolume = volume "-";
  "${mod}+Alt+Down" = volume "-";

  XF86AudioMute = volume "m";
  XF86AudioMicMute = volume "m --mic";

  # Control media
  XF86AudioPlay = media "play";
  XF86AudioPause = media "pause";
  "${mod}+Alt+Space" = media "play-pause";

  XF86AudioNext = media "next";
  "${mod}+Alt+Right" = media "next";

  XF86AudioPrev = media "previous";
  "${mod}+Alt+Left" = media "previous";
}
