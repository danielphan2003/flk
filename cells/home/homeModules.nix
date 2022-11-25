let
  l = builtins // nixlib.lib // digga.lib;
  inherit (inputs) digga nixlib;

  modules = l.rakeLeaves ./homeModules;
  flatModules = l.flattenTree modules;
in
  modules
  // {
    default = l.attrValues flatModules;
    extra = [
      inputs.arkenfox-nixos.hmModules.arkenfox
      inputs.impermanence.nixosModules.home-manager.impermanence
      inputs.hyprland.homeManagerModules.default
    ];
  }
