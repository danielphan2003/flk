{config, lib, pkgs, ...}:
let
  volumectl = cmd: "${pkgs.avizo}/bin/volumectl ${cmd}";
  playerctl = cmd: "${pkgs.playerctl}/bin/playerctl ${cmd}";
in
{
  services.sxhkd = {
    enable = true;
    keybindings = lib.mapAttrs (_: v: lib.mkDefault v) {
      "super + enter" = "$TERM";

      "super + d" = "$SXHKD_MENU";

      "ctrl + alt + delete" = "$SXHKD_POWER";

      # Control brightness
      "XF86MonBrightness{Down,Up}" = "${pkgs.avizo}/bin/lightctl {lower,raise}";

      # Control volume
      "XF86Audio{LowerVolume,RaiseVolume}" = volumectl "{-,+}";

      "super + alt + {down,up}" = volumectl "{-,+}";

      "XF86Audio{Mute,MicMute}" = volumectl "m {_,--mic}";

      # Control playback
      "XF86Audio{Play,Stop}" = playerctl "{play,pause}";

      "super + alt + space" = playerctl "play-pause";

      "XF86Audio{Prev,Next}" = playerctl "{previous,next}";

      "super + alt + {left,right}" = playerctl "{previous,next}";

      "alt + f4" = "kill";
    };
  };
}
