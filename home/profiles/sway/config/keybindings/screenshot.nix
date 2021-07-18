{ pkgs, mod, ... }:
let
  grim = "${pkgs.grim}/bin/grim";
  slurp = "${pkgs.slurp}/bin/slurp";

  # Notify when an action has been taken e.g. Screenshot copied; Screenshot saved etc.
  grimNotify = action: ''${pkgs.libnotify}/bin/notify-send -i "Screenshot ${action}"'';

  # Date time format for saved shots. Default location for shots is $XDG_PICTURES_DIR/scrn/scrn-$(date '+%F_%H-%m-%S').png
  grimFormat = ''$(${pkgs.xdg-user-dirs}/bin/xdg-user-dir PICTURES)/scrn/scrn-$$(date '+%F_%H-%m-%S').png && ${grimNotify "taken"}'';

  # Notify user when a shot is copied.
  processScreenshot = ''${pkgs.wl-clipboard}/bin/wl-copy -t image/png && ${grimNotify "copied"}'';
in
{
  # Clip full - copy the whole screen.
  "Print" = "exec ${grim} - | ${processScreenshot}";

  # Clip part - copy a region of the screen.
  "${mod}+Shift+S" = "exec ${grim} -g \"$(${slurp} -d)\" - | ${processScreenshot}";

  # Save full - same as clip full, but saving it for later.
  "${mod}+Print" = "exec ${grim} ${grimFormat}";

  # Save part - same as clip part, but saving it for later.
  "${mod}+Alt+S" = "exec ${grim} -g \"$(${slurp} -d)\" ${grimFormat}";
}
