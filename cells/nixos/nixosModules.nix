let
  l = builtins // nixlib.lib // digga.lib;
  inherit (inputs) digga nixlib;

  modules = l.rakeLeaves ./nixosModules;
  flatModules = l.flattenTree modules;
in
  modules
  // {
    default = l.attrValues flatModules;
    extra = with inputs; [
      agenix.nixosModules.age
      home-unstable.nixosModules.home-manager
      impermanence.nixosModules.impermanence
      {
        imports = [cell.nixosProfiles.users.root];

        home-manager = {
          # always use the system nixpkgs from the host's channel
          useGlobalPkgs = true;
          # and use the possible future default (see manual)
          useUserPackages = l.mkDefault true;
          extraSpecialArgs = {
            inputs = l.removeAttrs inputs ["self"];
            profiles = cells.home.homeProfiles;
            suites = cells.home.homeSuites;
          };
        };

        home-manager.sharedModules = with cells.home.homeModules;
          default ++ extra;
      }
    ];
  }
