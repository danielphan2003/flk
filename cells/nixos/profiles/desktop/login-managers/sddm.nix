{
  pkgs,
  lib,
  ...
}: {
  # TODO: maybe use wayland backend
  # environment.systemPackages = [ pkgs.westonLite ];
  services.xserver = {
    enable = true;
    updateDbusEnvironment = true;
    displayManager.sddm = {
      enable = true;
      autoNumlock = true;
      settings = {
        General = {
          DisplayServer = "x11-user";
          # DisplayServer = "wayland";
        };
        # Wayland = {
        #   CompositorCommand = "/run/current-system/sw/bin/weston --shell=/run/current-system/sw/lib/weston/fullscreen-shell.so";
        # };
      };
    };
  };
}
