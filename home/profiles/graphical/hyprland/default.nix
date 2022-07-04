{pkgs, ...}: {
  xdg.configFile."hypr/hyprland.conf".source = pkgs.substituteAll {
    src = ./hyprland.conf;
    term = "${pkgs.alacritty}/bin/alacritty";
    menu = "/nix/store/x99mf8sasdq0z1sjgqisb2cbvw53zr7r-nwg-drawer-0.2.8/bin/nwg-drawer";
    powermenu = "/nix/store/xrn56d7dqsza7r2h8jjf5k72n80j9jc4-nwg-launchers-0.6.3/bin/nwgbar";
    volume = "~/.config/hypr/scripts/volume";
    backlight = "~/.config/hypr/scripts/brightness";
    screenshot = "~/.config/hypr/scripts/screenshot";
    lockscreen = "@lockscreen@/nix/store/yngr2ax3mdhfbi9s7zcn1i2k39jfnawl-lock.sh";
    wlogout = "~/.config/hypr/scripts/wlogout";
    colorpicker = "~/.config/hypr/scripts/colorpicker";
    files = "nautilus";
    editor = "codium";
    browser = "firefox";
  };
}
