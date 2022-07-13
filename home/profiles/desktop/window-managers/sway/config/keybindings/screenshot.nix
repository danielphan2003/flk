{pkgs, ...}: let
  flameshot = "${pkgs.flameshot}/bin/flameshot";
in {
  services.sxhkd.keybindings = {
    # Clip full - copy the whole screen.
    "print" = "${flameshot} screen -c";

    # Clip part - copy a region of the screen.
    "super + shift + s" = "${flameshot} gui";
  };
}
