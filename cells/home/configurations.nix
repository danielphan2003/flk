{
  inputs,
  cell
}: let
  l = builtins // nixlib.lib // cells.flk.lib;
  inherit (inputs) cells nixlib;
in {
  specialArgs = {
    inherit inputs cells;
    inherit (cell) profiles suites;
    self = inputs.self.outPath;
  };

  lib = l.extend (lfinal: lprev: {
    flk = cells.flk.lib;
  });

  modules = with inputs; [
    arkenfox-nixos.hmModules.arkenfox
    impermanence.nixosModules.home-manager.impermanence
    hyprland.homeManagerModules.default
  ];
}
