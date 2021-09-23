{
  description = "A highly structured configuration database.";

  nixConfig = {
    extra-experimental-features = "nix-command flakes ca-references";
    extra-substituters = "https://cache.nixos.org https://nrdxp.cachix.org https://nix-community.cachix.org https://dan-cfg.cachix.org https://nixpkgs-wayland.cachix.org https://dram.cachix.org https://dcompass.cachix.org";
    extra-trusted-public-keys = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= dan-cfg.cachix.org-1:elcVKJWjnDs1zzZ/Fs93FLOFS13OQx1z0TxP0Q7PH9o= nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA= dram.cachix.org-1:baoy1SXpwYdKbqdTbfKGTKauDDeDlHhUpC+QuuILEMY= dcompass.cachix.org-1:uajJEJ1U9uy/y260jBIGgDwlyLqfL1sD5yaV/uWVlbk=";
  };

  inputs = {
    nixos.url = "nixpkgs/release-21.05";
    latest.url = "nixpkgs/nixos-unstable";

    dan-nixpkgs = {
      url = github:danielphan2003/nixpkgs;
      inputs = {
        nixos.follows = "nixos";
        latest.follows = "latest";
        digga.follows = "digga";
        bud.follows = "bud";
        nvfetcher.follows = "nvfetcher";
      };
    };

    nix = { url = github:nixos/nix/c81f976; };

    digga = {
      url = github:divnix/digga;
      inputs = {
        nix.follows = "nix";
        nixpkgs.follows = "nixos";
        nixlib.follows = "nixos";
        home-manager.follows = "home";
      };
    };

    bud = {
      url = github:divnix/bud;
      inputs = {
        nixpkgs.follows = "nixos";
        devshell.follows = "digga/devshell";
      };
    };

    home = {
      url = github:nix-community/home-manager/release-21.05;
      inputs.nixpkgs.follows = "nixos";
    };

    darwin = {
      url = github:LnL7/nix-darwin;
      inputs.nixpkgs.follows = "latest";
    };

    deploy.follows = "digga/deploy";

    agenix = {
      url = github:ryantm/agenix;
      inputs.nixpkgs.follows = "latest";
    };

    nvfetcher = {
      url = github:berberman/nvfetcher;
      inputs = {
        nixpkgs.follows = "latest";
        flake-compat.follows = "digga/deploy/flake-compat";
        flake-utils.follows = "digga/flake-utils-plus/flake-utils";
      };
    };

    ci-agent = {
      url = github:hercules-ci/hercules-ci-agent;
      inputs = {
        nix-darwin.follows = "darwin";
        nixos-20_09.follows = "nixos";
        nixos-unstable.follows = "latest";
        flake-compat.follows = "digga/deploy/flake-compat";
      };
    };

    nixos-hardware = { url = "github:nixos/nixos-hardware"; };

    naersk = {
      url = github:nmattia/naersk;
      inputs.nixpkgs.follows = "latest";
    };

    firefox-nightly = {
      url = github:colemickens/flake-firefox-nightly;
      inputs.nixpkgs.follows = "latest";
    };

    nixpkgs-wayland = {
      url = github:colemickens/nixpkgs-wayland;
      inputs.nixpkgs.follows = "latest";
    };

    netkit = {
      url = github:icebox-nix/netkit.nix;
      inputs = {
        nixpkgs.follows = "latest";
        flake-utils.follows = "digga/flake-utils-plus/flake-utils";
      };
    };

    dcompass = {
      url = github:compassd/dcompass;
      inputs.utils.follows = "digga/flake-utils-plus/flake-utils";
    };

    anbox = { url = github:samueldr/nixpkgs/feature/anbox-2021-06-refresh; };

    impermanence = {
      url = github:nix-community/impermanence/systemd-service-files;
      flake = false;
    };

    nix-dram = {
      url = github:dramforever/nix-dram;
      inputs.nixpkgs.follows = "nix/nixpkgs";
    };

    qnr = { url = github:divnix/quick-nix-registry; };

    vs-ext = { url = github:divnix/vs-ext; };

    rnix-lsp = {
      url = github:nix-community/rnix-lsp;
      inputs.nixpkgs.follows = "latest";
    };

    fenix = { url = github:nix-community/fenix; };

    npmlock2nix = {
      url = github:nix-community/npmlock2nix;
      flake = false;
    };

    gomod2nix = {
      url = github:tweag/gomod2nix;
      inputs.nixpkgs.follows = "latest";
    };
  };

  outputs =
    { self
    , nixos
    , latest
    , dan-nixpkgs

    , digga
    , bud
    , home
    , deploy
    , agenix
    , nvfetcher
    , ci-agent
    , nixos-hardware

    , nur

    , firefox-nightly
    , nixpkgs-wayland
    , netkit
    , dcompass
    , anbox
    , nix-dram
    , qnr
    , vs-ext
    , rnix-lsp

    , fenix
    , gomod2nix

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

              nixpkgs-wayland.overlay-egl
              nix-dram.overlay
              vs-ext.overlay

              fenix.overlay
              gomod2nix.overlay

              dan-nixpkgs.overlay
              (import ./pkgs/default.nix { inherit inputs; })
            ];
          };
          latest = { };
          anbox = { };
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

        deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations {
          themachine.profiles.system.sshUser = "root";
          pik2.profiles.system.sshUser = "root";
        };

        defaultTemplate = self.templates.bud;
        templates.bud.path = ./.;
        templates.bud.description = "bud template";

        supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

      }
    //
    {
      budModules = { devos = import ./bud; };
    }
  ;
}
