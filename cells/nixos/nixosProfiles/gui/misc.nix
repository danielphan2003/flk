{
  lib,
  pkgs,
  profiles,
  ...
}: let
  inherit (lib) mkDefault mkForce;
in {
  imports = [profiles.fonts.minimal];

  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      xdg-utils
      nixos-icons # needed for gnome and pantheon about dialog, nixos-manual and maybe more
      ;
  };

  xdg = {
    autostart.enable = true;
    menus.enable = true;
    mime.enable = true;
    icons.enable = true;
  };

  # The default max inotify watches is 8192.
  # Nowadays most apps require a good number of inotify watches,
  # the value below is used by default on several other distros.
  boot.kernel.sysctl."fs.inotify.max_user_instances" = mkForce 524288;
  boot.kernel.sysctl."fs.inotify.max_user_watches" = mkForce 524288;
}
