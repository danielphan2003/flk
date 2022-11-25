{pkgs, ...}: {
  programs.waybar.settings.mainBar."custom/power" = {
    format = "";
    on-click = "exec ${pkgs.nwg-launchers}/bin/nwgbar -o 0.2";
    escape = true;
    tooltip = false;
  };
}
