{
  config,
  lib,
  ...
}: {
  imports = lib.flk.getNixFiles ./modules;

  programs.waybar = {
    enable = true;

    systemd.enable = true;

    settings.mainBar = {
      height = 40;
      position = "bottom";

      modules-left = [
        "sway/workspaces"
      ];

      modules-center = [];

      modules-right = [
        "idle_inhibitor"
        "tray"
        "pulseaudio"
        "network"
        "clock"
        "custom/power"
      ];
    };

    style = lib.fileContents ./style.css;
  };
}
