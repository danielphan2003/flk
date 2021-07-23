{
  description = "A highly structured configuration database.";

  nixConfig = {
    extra-experimental-features = "nix-command flakes ca-references";
    extra-substituters = "https://cache.nixos.org https://nrdxp.cachix.org https://nix-community.cachix.org https://nixbld.m-labs.hk https://dan-cfg.cachix.org https://nixpkgs-wayland.cachix.org";
    extra-trusted-public-keys = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= dan-cfg.cachix.org-1:elcVKJWjnDs1zzZ/Fs93FLOFS13OQx1z0TxP0Q7PH9o= nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA=";
  };

  inputs =
    {
      nixos.url = "nixpkgs/release-21.05";
      latest.url = "nixpkgs";

      digga.url = "github:divnix/digga";
      digga.inputs.nixpkgs.follows = "nixos";
      digga.inputs.nixlib.follows = "nixos";
      digga.inputs.home-manager.follows = "home";

      bud.url = "github:divnix/bud";
      bud.inputs.nixpkgs.follows = "nixos";
      bud.inputs.devshell.follows = "digga/devshell";

      home.url = "github:nix-community/home-manager/release-21.05";
      home.inputs.nixpkgs.follows = "nixos";

      darwin.url = "github:LnL7/nix-darwin";
      darwin.inputs.nixpkgs.follows = "latest";

      deploy.follows = "digga/deploy";

      agenix.url = "github:ryantm/agenix";
      agenix.inputs.nixpkgs.follows = "latest";

      nvfetcher.url = "github:berberman/nvfetcher";
      nvfetcher.inputs.nixpkgs.follows = "latest";
      nvfetcher.inputs.flake-compat.follows = "digga/deploy/flake-compat";
      nvfetcher.inputs.flake-utils.follows = "digga/flake-utils-plus/flake-utils";

      ci-agent.url = "github:hercules-ci/hercules-ci-agent";
      ci-agent.inputs.nix-darwin.follows = "darwin";
      ci-agent.inputs.nixos-20_09.follows = "nixos";
      ci-agent.inputs.nixos-unstable.follows = "latest";
      ci-agent.inputs.flake-compat.follows = "digga/deploy/flake-compat";

      naersk.url = "github:nmattia/naersk";
      naersk.inputs.nixpkgs.follows = "latest";

      nixos-hardware.url = "github:nixos/nixos-hardware";

      # start ANTI CORRUPTION LAYER
      # remove after https://github.com/NixOS/nix/pull/4641
      nixpkgs.follows = "nixos";
      nixlib.follows = "digga/nixlib";
      blank.follows = "digga/blank";
      flake-utils-plus.follows = "digga/flake-utils-plus";
      flake-utils.follows = "digga/flake-utils";
      # end ANTI CORRUPTION LAYER

      firefox-nightly.url = "github:colemickens/flake-firefox-nightly/52035b6";
      firefox-nightly.inputs.nixpkgs.follows = "nixos";

      nixpkgs-wayland.url = "github:colemickens/nixpkgs-wayland";

      anbox.url = "github:samueldr/nixpkgs/feature/anbox-2021-06-refresh";

      impermanence = {
        url = "github:nix-community/impermanence";
        flake = false;
      };
    };

  outputs =
    { self
    , latest
    , digga
    , bud
    , nixos
    , ci-agent
    , home
    , nixos-hardware
    , nur
    , agenix
    , nvfetcher
    , deploy

    , firefox-nightly
    , nixpkgs-wayland
    , samueldr-anbox

    , ...
    } @ inputs:
    digga.lib.mkFlake
      {
        inherit self inputs;

        channelsConfig = { allowUnfree = true; };

        channels = {
          nixos = {
            imports = [ (digga.lib.importOverlays ./overlays) ];
            overlays = [
              digga.overlays.patchedNix
              nur.overlay
              agenix.overlay
              nvfetcher.overlay
              deploy.overlay
              ./pkgs/default.nix
              nixpkgs-wayland.overlay
              (final: prev: {
                firefox-nightly-bin =
                  if prev.system == "x86_64-linux"
                  then firefox-nightly.packages.${prev.system}.firefox-nightly-bin
                  else prev.firefox;
              })
            ];
          };
          latest = { };
        };

        lib = import ./lib { lib = digga.lib // nixos.lib; };

        sharedOverlays = [
          (final: prev: {
            __dontExport = true;
            lib = prev.lib.extend (lfinal: lprev: {
              our = self.lib;
            });
          })
        ];

        nixos = ./nixos;

        home = ./home;

        devshell = ./shell;

        homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;

        deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations { };

        defaultTemplate = self.templates.bud;
        templates.bud.path = ./.;
        templates.bud.description = "bud template";

      }
    //
    {
      budModules = { devos = import ./pkgs/shells/bud; };
    }
  ;
}
