{
  description = "A highly structured configuration database.";

  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    extra-substituters = "https://cache.nixos.org https://nrdxp.cachix.org https://nix-community.cachix.org https://dan-cfg.cachix.org https://nixpkgs-wayland.cachix.org";
    extra-trusted-public-keys = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= dan-cfg.cachix.org-1:elcVKJWjnDs1zzZ/Fs93FLOFS13OQx1z0TxP0Q7PH9o= nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA=";
  };

  inputs = {
    nixos.url = "nixpkgs/release-21.11";
    latest.url = "nixpkgs/nixos-unstable";

    dan-nixpkgs = {
      url = github:danielphan2003/nixpkgs;
      inputs = {
        nixos.follows = "nixos";
        latest.follows = "nixos";
        digga.follows = "digga";
        bud.follows = "bud";
        nvfetcher.follows = "nvfetcher";
      };
    };

    digga = {
      url = github:divnix/digga/cleanup-dar;
      inputs = {
        nixpkgs.follows = "nixos";
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
      url = github:nix-community/home-manager/release-21.11;
      inputs.nixpkgs.follows = "nixos";
    };

    darwin = {
      url = github:LnL7/nix-darwin;
      inputs.nixpkgs.follows = "nixos";
    };

    deploy = {
      url = github:serokell/deploy-rs; # github:input-output-hk/deploy-rs;
      inputs = {
        nixpkgs.follows = "nixos";
        utils.follows = "digga/flake-utils-plus/flake-utils";
      };
    };

    agenix = {
      url = github:ryantm/agenix; # github:yaxitech/ragenix;
      inputs = {
        nixpkgs.follows = "nixos";
        # flake-utils.follows = "digga/flake-utils-plus/flake-utils";
        # rust-overlay.follows = "rust-overlay";
        # naersk.follows = "naersk";
      };
    };

    nvfetcher = {
      url = github:berberman/nvfetcher;
      inputs = {
        nixpkgs.follows = "nixos";
        flake-compat.follows = "deploy/flake-compat";
        flake-utils.follows = "digga/flake-utils-plus/flake-utils";
      };
    };

    nixos-hardware = { url = "github:nixos/nixos-hardware"; };

    ###############################################################

    beautysh = {
      url = github:lovesegfault/beautysh;
      inputs = {
        nixpkgs.follows = "nixos";
        flake-utils.follows = "digga/flake-utils-plus/flake-utils";
        poetry2nix.follows = "poetry2nix";
      };
    };

    ci-agent = {
      url = github:hercules-ci/hercules-ci-agent;
      inputs = {
        nix-darwin.follows = "darwin";
        nixos-20_09.follows = "nixos";
        nixos-unstable.follows = "nixos";
        flake-compat.follows = "deploy/flake-compat";
      };
    };

    dcompass = {
      url = github:compassd/dcompass;
      inputs = {
        nixpkgs.follows = "nixos";
        utils.follows = "digga/flake-utils-plus/flake-utils";
        rust-overlay.follows = "rust-overlay";
      };
    };

    eww = {
      url = github:elkowar/eww;
      inputs = {
        flake-compat.follows = "deploy/flake-compat";
        nixpkgs.follows = "nixos";
        flake-utils.follows = "digga/flake-utils-plus/flake-utils";
        fenix.follows = "fenix";
        naersk.follows = "naersk";
      };
    };

    fenix = { url = github:nix-community/fenix; };

    firefox-nightly = {
      url = github:colemickens/flake-firefox-nightly;
      inputs.nixpkgs.follows = "nixos";
    };

    gomod2nix = {
      url = github:tweag/gomod2nix;
      inputs = {
        nixpkgs.follows = "nixos";
        utils.follows = "digga/flake-utils-plus/flake-utils";
      };
    };

    impermanence = {
      url = github:nix-community/impermanence;
      flake = false;
    };

    manix = {
      url = github:kreisys/manix;
      inputs = {
        nixpkgs.follows = "nixos";
        flake-utils.follows = "digga/flake-utils-plus/flake-utils";
      };
    };

    naersk = {
      url = github:nix-community/naersk;
      inputs.nixpkgs.follows = "nixos";
    };

    nix-gaming = {
      url = github:fufexan/nix-gaming;
      inputs = {
        nixpkgs.follows = "nixos";
        utils.follows = "digga/flake-utils-plus";
      };
    };

    nixpkgs-wayland = {
      url = github:nix-community/nixpkgs-wayland;
      inputs = {
        nixpkgs.follows = "nixos";
        cachix.follows = "nixos";
      };
    };

    npmlock2nix = {
      url = github:nix-community/npmlock2nix;
      flake = false;
    };

    peerix = {
      url = github:cid-chan/peerix;
      inputs = {
        nixpkgs.follows = "nixos";
        flake-compat.follows = "deploy/flake-compat";
        flake-utils.follows = "digga/flake-utils-plus/flake-utils";
      };
    };

    poetry2nix = {
      url = github:nix-community/poetry2nix;
      inputs = {
        nixpkgs.follows = "nixos";
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
        nixpkgs.follows = "nixos";
        flake-utils.follows = "digga/flake-utils-plus/flake-utils";
      };
    };

    devos-ext-lib = {
      url = github:danielphan2003/devos-ext-lib/other-extensions;
      # url = "/home/danie/src/github.com/danielphan2003/devos-ext-lib";
      inputs.nixpkgs.follows = "nixos";
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
    , darwin
    , deploy
    , agenix
    , nixos-hardware

      ###############################################################

    , beautysh
    , ci-agent
    , dcompass
    , fenix
    , firefox-nightly
    , gomod2nix
      # , impermanence
    , manix
    , naersk
    , nix-gaming
    , nixpkgs-wayland
      # , npmlock2nix
    , peerix
    , poetry2nix
    , qnr
    , rnix-lsp
    , rust-overlay
    , devos-ext-lib
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
              agenix.overlay

              dcompass.overlay

              peerix.overlay

              fenix.overlay
              gomod2nix.overlay
              naersk.overlay
              poetry2nix.overlay
            ]
            ++ (builtins.attrValues dan-nixpkgs.overlays)
            ++ devos-ext-lib.overlays.minecraft-mods
            ++ devos-ext-lib.overlays.papermc
            ++ devos-ext-lib.overlays.python3Packages
            ++ devos-ext-lib.overlays.vimPlugins
            ++ devos-ext-lib.overlays.vscode-extensions
            ++ [ (import ./pkgs/default.nix { inherit inputs; }) ];
          };
          latest = {
            overlays = [ nixpkgs-wayland.overlay ];
          };
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
