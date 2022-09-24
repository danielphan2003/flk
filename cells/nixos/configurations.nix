{
  inputs,
  cell,
}:
let
  l = builtins // nixlib.lib // cells.std.lib;
  inherit (inputs) cells nixlib;
in {
  specialArgs = {
    inherit cells;
    inherit (cell) profiles suites;
    inputs = l.removeAttrs inputs ["cells" "self"];
    self = inputs.self.outPath;
  };

  lib = l.extend (lfinal: lprev: {
    flk = cells.flk.lib;
  });

  extraModules = with inputs; [
    colmena.nixosModules.deploymentOptions
  ];

  modules = with inputs; [
    agenix.nixosModules.age
    flake-utils-plus.nixosModules.autoGenFromInputs
    home.nixosModules.home-manager
    hyprland.nixosModules.default
    impermanence.nixosModules.impermanence
    nix-gaming.nixosModules.pipewireLowLatency
    peerix.nixosModules.peerix
    qnr.nixosModules.local-registry

    {
      home-manager.extraSpecialArgs = {
        inherit
          (cells.home)
          profiles
          suites
          ;
      };

      home-manager.sharedModules = cells.home.modules.default;

      nixpkgs.overlays =
        l.flatten (l.attrValues (l.trim cells ["overlays"]));
    }
  ];
}
