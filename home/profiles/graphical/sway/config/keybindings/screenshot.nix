{ pkgs, mod }:
let flameshot = "${pkgs.flameshot}/bin/flameshot"; in
{
  # Clip full - copy the whole screen.
  "Print" = "exec ${flameshot} screen -c";

  # Clip part - copy a region of the screen.
  "${mod}+Shift+S" = "exec ${flameshot} gui";
}
