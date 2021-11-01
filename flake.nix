{
  description = "A highly structured configuration database.";

  nixConfig = {
    extra-experimental-features = "nix-command flakes ca-references";
    extra-substituters = "https://cache.nixos.org https://nrdxp.cachix.org https://nix-community.cachix.org https://dan-cfg.cachix.org https://nixpkgs-wayland.cachix.org";
    extra-trusted-public-keys = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= dan-cfg.cachix.org-1:elcVKJWjnDs1zzZ/Fs93FLOFS13OQx1z0TxP0Q7PH9o= nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA=";
  };

  inputs = {
    nixos.url = "nixpkgs/release-21.05";
    latest.url = "nixpkgs/nixos-unstable";

    dan-nixpkgs = {
      url = github:danielphan2003/nixpkgs;
      inputs = {
        nixos.follows = "nixos";
        latest.follows = "latest";
        nix.follows = "nix";
        digga.follows = "digga";
        bud.follows = "bud";
        nvfetcher.follows = "nvfetcher";
      };
    };

    nix = { url = github:nixos/nix; };

    digga = {
      url = github:divnix/digga;
      inputs = {
        nix.follows = "nix";
        nixpkgs.follows = "nixos";
        latest.follows = "latest";
        nixlib.follows = "nixos";
        home-manager.follows = "home";
        deploy.follows = "deploy";
      };
    };

    bud = {
      url = github:divnix/bud;
      inputs = {
        nixpkgs.follows = "nixos";
        devshell.follows = "digga/devshell";
        beautysh.follows = "beautysh";
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

    deploy = {
      url = github:serokell/deploy-rs;
      inputs = {
        nixpkgs.follows = "latest";
        utils.follows = "digga/flake-utils-plus/flake-utils";
      };
    };

    ragenix = {
      url = github:yaxitech/ragenix;
      inputs = {
        nixpkgs.follows = "latest";
        flake-utils.follows = "digga/flake-utils-plus/flake-utils";
        rust-overlay.follows = "rust-overlay";
        naersk.follows = "naersk";
      };
    };

    nvfetcher = {
      url = github:berberman/nvfetcher;
      inputs = {
        nixpkgs.follows = "latest";
        flake-compat.follows = "deploy/flake-compat";
        flake-utils.follows = "digga/flake-utils-plus/flake-utils";
      };
    };

    nixos-hardware = { url = "github:nixos/nixos-hardware"; };

    ###############################################################

    beautysh = {
      url = github:lovesegfault/beautysh;
      inputs = {
        nixpkgs.follows = "latest";
        flake-utils.follows = "digga/flake-utils-plus/flake-utils";
      };
    };

    ci-agent = {
      url = github:hercules-ci/hercules-ci-agent;
      inputs = {
        nix-darwin.follows = "darwin";
        nixos-20_09.follows = "nixos";
        nixos-unstable.follows = "latest";
        flake-compat.follows = "deploy/flake-compat";
      };
    };

    dcompass = {
      url = github:compassd/dcompass;
      inputs = {
        nixpkgs.follows = "latest";
        utils.follows = "digga/flake-utils-plus/flake-utils";
        rust-overlay.follows = "rust-overlay";
      };
    };

    eww = {
      url = github:elkowar/eww;
      inputs = {
        flake-compat.follows = "deploy/flake-compat";
        nixpkgs.follows = "latest";
        flake-utils.follows = "digga/flake-utils-plus/flake-utils";
        fenix.follows = "fenix";
        naersk.follows = "naersk";
      };
    };

    fenix = { url = github:nix-community/fenix; };

    firefox-nightly = {
      url = github:colemickens/flake-firefox-nightly;
      inputs.nixpkgs.follows = "latest";
    };

    gomod2nix = {
      url = github:tweag/gomod2nix;
      inputs = {
        nixpkgs.follows = "latest";
        utils.follows = "digga/flake-utils-plus/flake-utils";
      };
    };

    impermanence = {
      url = github:nix-community/impermanence/systemd-service-files;
      flake = false;
    };

    naersk = {
      url = github:nix-community/naersk;
      inputs.nixpkgs.follows = "latest";
    };

    nix-gaming = {
      url = github:fufexan/nix-gaming;
      inputs = {
        nixpkgs.follows = "latest";
        utils.follows = "digga/flake-utils-plus";
      };
    };

    nixpkgs-wayland = {
      url = github:nix-community/nixpkgs-wayland;
      inputs = {
        nixpkgs.follows = "latest";
        cachix.follows = "nixos";
      };
    };

    npmlock2nix = {
      url = github:andir/npmlock2nix/yarn-support;
      flake = false;
    };

    peerix = {
      url = github:danielphan2003/peerix/overlay;
      inputs = {
        nixpkgs.follows = "latest";
        flake-compat.follows = "deploy/flake-compat";
        flake-utils.follows = "digga/flake-utils-plus/flake-utils";
      };
    };

    qnr = { url = github:divnix/quick-nix-registry; };

    rnix-lsp = {
      url = github:nix-community/rnix-lsp;
      inputs = {
        nixpkgs.follows = "nixos";
        utils.follows = "digga/flake-utils-plus/flake-utils";
        naersk.follows = "naersk";
      };
    };

    rust-overlay = {
      url = github:oxalica/rust-overlay;
      inputs = {
        nixpkgs.follows = "latest";
        flake-utils.follows = "digga/flake-utils-plus/flake-utils";
      };
    };

    vs-ext = {
      url = github:divnix/vs-ext;
      inputs = {
        nixpkgs.follows = "nixos";
        devshell.follows = "digga/devshell";
        digga.follows = "digga";
        bud.follows = "bud";
        flake-utils.follows = "digga/flake-utils-plus/flake-utils";
        flake-utils-plus.follows = "digga/flake-utils-plus";
      };
    };

    waydroid = { url = github:CajuM/nixpkgs/waydroid-module; };
  };

  outputs =
    { self

    , nixos
    , latest
    , dan-nixpkgs

    , nix
    , digga
    , bud
    , home
    , darwin
    , deploy
    , ragenix
    , nixos-hardware

      ###############################################################

    , beautysh
    , ci-agent
    , dcompass
    , fenix
    , firefox-nightly
    , gomod2nix
      # , impermanence
    , naersk
    , nix-gaming
    , nixpkgs-wayland
      # , npmlock2nix
    , peerix
    , qnr
    , rnix-lsp
    , rust-overlay
    , vs-ext
    , waydroid
    , ...
    } @ inputs:
    digga.lib.mkFlake
      {
        inherit self inputs;

        channelsConfig = { allowUnfree = true; };

        channels = {
          nixos = {
            imports = [ (digga.lib.importOverlays ./overlays) ];
            overlays =
              [
                digga.overlays.patchedNix
                vs-ext.overlay
              ]
              ++ (builtins.attrValues dan-nixpkgs.overlays)
              ++ [ (import ./pkgs/default.nix { inherit inputs; }) ];
          };
          latest = {
            overlays = [
              deploy.overlay

              ragenix.overlay

              dcompass.overlay

              nixpkgs-wayland.overlay-egl

              peerix.overlay

              fenix.overlay
              naersk.overlay
              gomod2nix.overlay
            ];
          };
          waydroid = { };
        };

        lib = import ./lib { lib = digga.lib // nixos.lib; };

        home = ./home;

        nixos = ./nixos;

        deploy = import ./deploy inputs;

        devshell = ./shell;

        homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;

        defaultTemplate = self.templates.bud;
        templates.bud.path = ./.;
        templates.bud.description = "bud template";

        sharedOverlays = [
          (final: prev: {
            __dontExport = true;
            lib = prev.lib.extend (lfinal: lprev: {
              our = self.lib;
            });
          })
        ];

        supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

      }
    //
    {
      budModules = { devos = import ./bud; };
    }
  ;
}
