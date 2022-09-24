{pkgs, ...}: {
  programs.sway.enable = true;

  environment.etc."sway/config".text = ''
    include ${pkgs.sway}/etc/sway/config
    bindsym Mod1+Return ${pkgs.wezterm}/bin/wezterm
    exec systemctl --user import-environment
  '';
}
