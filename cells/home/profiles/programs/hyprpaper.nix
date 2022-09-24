{nixosConfig, ...}: {
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${nixosConfig.stylix.image}
    wallpaper = HDMI-A-1,${nixosConfig.stylix.image}
  '';
}
