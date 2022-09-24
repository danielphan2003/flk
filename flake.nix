{
  description = "A highly structured configuration database.";

  inputs = {
    nixos.url = "nixpkgs/nixos-22.05";
    nixos-unstable.url = "nixpkgs/nixos-unstable";

    # nixpkgs is a local registry via https://github.com/divnix/quick-nix-registry
    # to be more accessible, uncomment this:
    # nixpkgs.url = "github:NixOS/nixpkgs";
    nixpkgs.url = "nixpkgs";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    nixpkgs-lock.url = "nixpkgs/nixpkgs-unstable";
    latest.url = "nixpkgs";
    bootspec-nixpkgs.url = "github:DeterminateSystems/nixpkgs";
    nixlib.url = "github:nix-community/nixpkgs.lib";
    flake-utils.url = "github:numtide/flake-utils";
  };

  # Std Inputs
  inputs = {
    std.url = "github:divnix/std";
    std.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = {
    self,
    std,
    nixlib,
    flake-utils,
    ...
  } @ inputs: let
    systems = ["x86_64-linux" "aarch64-linux"];

    l = nixlib.lib // builtins // self.lib // flake-utils.lib;

    # exports have no system, pick one
    defaultSystem = "x86_64-linux";
    exports = self.${defaultSystem};
  in
    std.growOn {
      inherit inputs systems;

      cellsFrom = ./cells;

      cellBlocks = [
        # modules implement
        (std.functions "modules")

        # profiles activate
        (std.functions "profiles")

        # suites aggregate profiles
        (std.functions "suites")

        # builders
        (std.functions "builders")

        (std.functions "users")

        (std.functions "hosts")

        # configurations can be deployed
        # (std.data "colmena")
        (std.functions "configurations")

        # devshells can be entered
        (std.devshells "devshells")

        # jobs can be run
        (std.runnables "jobs")

        # # packages can be installed
        # (std.functions "packages")

        # overlays
        (std.functions "overlays")
        (std.functions "sharedOverlays")

        # library holds shared knowledge made code
        (std.functions "lib")
      ];
    }
    {
      inherit defaultSystem;
    }
    {
      # ... with `nix develop` - `default` is a special target for `nix develop`
      devShells = std.harvest self ["flk" "devshells"];
    }
    {
      # get all cells with `lib` target, and merge it into a single attrset
      lib = let
        # bootstrapping lib from cells.std.lib
        std.lib = inputs.std.harvest self ["std" "lib"];
      in
        std.lib.${defaultSystem}.trimBy exports ["lib"];
    }
    {
      # overlays
      overlays = l.std.trim exports ["overlays"];
    }
    {
      # packages = l.eachSystem systems (system: let
      #   # Little hack, we make sure that `legacyPackages` contains `nix` to make sure that we are dealing with nixpkgs.
      #   # For some odd reason `devshell` contains `legacyPackages` out put as well
      #   filterChannels = l.filterAttrs (_: value: value ? legacyPackages && value.legacyPackages.x86_64-linux ? nix);

      #   channels = filterChannels inputs;

      #   packagesBuilder = self.overlays.default;

      #   packages = l.mapAttrs (_: v: let
      #     pkgs = std.deSystemize system v.legacyPackages;
      #   in packagesBuilder v v) channels;
      # in
      #   packages // packages.nixos);
    }
    {
      # tool: colmena
      # colmena = l.std.trim exports ["colmenaConfigurations"];
    }
    {
      # homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;
    }
    {
      nixosConfigurations = l.flk.mkNixosConfigurations exports;
    };

  # --- Flake Local Nix Configuration ----------------------------
  # TODO: adopt spongix
  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://colmena.cachix.org"
      "https://dan-cfg.cachix.org"
      "https://danth.cachix.org"
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://nrdxp.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
      "dan-cfg.cachix.org-1:elcVKJWjnDs1zzZ/Fs93FLOFS13OQx1z0TxP0Q7PH9o="
      "danth.cachix.org-1:wpodfSL7suXRc/rJDZZUptMa1t4MJ795hemRN0q84vI="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
    ];
  };
  # --------------------------------------------------------------
}
