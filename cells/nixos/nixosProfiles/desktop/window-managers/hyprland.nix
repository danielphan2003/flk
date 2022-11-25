{inputs, ...}: {
  imports = [inputs.hyprland.nixosModules.default];

  programs.hyprland.enable = true;

  services.xserver.displayManager.defaultSession = "hyprland";
}
