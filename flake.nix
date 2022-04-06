{
  description = "A highly structured configuration database.";

  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    extra-substituters = "https://cache.nixos.org https://nrdxp.cachix.org https://nix-community.cachix.org https://dan-cfg.cachix.org https://nixpkgs-wayland.cachix.org";
    extra-trusted-public-keys = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= dan-cfg.cachix.org-1:elcVKJWjnDs1zzZ/Fs93FLOFS13OQx1z0TxP0Q7PH9o= nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA=";
  };

  inputs = {
    nixos.url = "nixpkgs/nixos-21.11";
    latest.url = "nixpkgs/nixos-unstable";
    nixlib.url = "github:nix-community/nixpkgs.lib";

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
      url = github:divnix/digga;
      inputs = {
        nixpkgs.follows = "nixos";
        latest.follows = "latest";
        nixlib.follows = "nixlib";
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
      inputs.nixpkgs.follows = "nixlib";
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
        nixpkgs.follows = "nixos";
        flake-utils.follows = "digga/flake-utils-plus/flake-utils";
      };
    };

    nixos-hardware = {url = "github:nixos/nixos-hardware";};

    ###############################################################

    argonone-utils = {url = github:danielphan2003/argonone-utils/flake-nixosModules;};

    beautysh = {
      url = github:lovesegfault/beautysh;
      inputs = {
        nixpkgs.follows = "nixos";
        flake-utils.follows = "digga/flake-utils-plus/flake-utils";
        poetry2nix.follows = "poetry2nix";
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

    fenix = {url = github:nix-community/fenix;};

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

    impermanence = {url = github:nix-community/impermanence;};

    manix = {
      url = github:kreisys/manix;
      inputs = {
        nixpkgs.follows = "nixos";
        flake-utils.follows = "digga/flake-utils-plus/flake-utils";
      };
    };

    matrix-appservices = {url = github:Pacman99/nixpkgs/matrix-appservices;};

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

    nixos-mailserver = {
      url = gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-21.11;
      inputs = {
        utils.follows = "digga/flake-utils-plus/flake-utils";
        nixpkgs.follows = "latest";
        nixpkgs-21_11.follows = "nixos";
      };
    };

    nixos-mailserver-latest = {
      url = gitlab:simple-nixos-mailserver/nixos-mailserver;
      inputs = {
        utils.follows = "digga/flake-utils-plus/flake-utils";
        nixpkgs.follows = "latest";
        nixpkgs-21_11.follows = "nixos";
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

    qnr = {url = github:divnix/quick-nix-registry;};

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

  outputs = {
    self,
    nixos,
    latest,
    dan-nixpkgs,
    digga,
    bud,
    home,
    darwin,
    deploy,
    agenix,
    nixos-hardware,
    ###############################################################
    argonone-utils,
    beautysh,
    dcompass,
    fenix,
    firefox-nightly,
    gomod2nix,
    impermanence,
    manix,
    matrix-appservices,
    naersk,
    nix-gaming,
    nixpkgs-wayland,
    nixos-mailserver,
    nixos-mailserver-latest,
    # , npmlock2nix
    peerix,
    poetry2nix,
    qnr,
    rnix-lsp,
    rust-overlay,
    devos-ext-lib,
    ...
  } @ inputs:
    digga.lib.mkFlake
    {
      inherit self inputs;

      channelsConfig = {allowUnfree = true;};

      channels = {
        nixos = {
          imports = [(digga.lib.importOverlays ./overlays)];
          overlays =
            [
              dcompass.overlay
              fenix.overlay
              gomod2nix.overlay
              naersk.overlay
              peerix.overlay
              poetry2nix.overlay
              rust-overlay.overlay
            ]
            ++ (builtins.attrValues dan-nixpkgs.overlays)
            ++ (builtins.attrValues devos-ext-lib.overlays)
            ++ [(import ./pkgs {inherit inputs;})];
        };
        latest = {
          overlays = [
            nixpkgs-wayland.overlay
            agenix.overlay
          ];
        };
      };

      ###############################################################

      lib = import ./lib {lib = digga.lib // nixos.lib;};

      home = ./home;

      nixos = ./nixos;

      deploy = import ./deploy inputs;

      homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;

      sharedOverlays = [
        (final: prev: {
          __dontExport = true;
          lib = prev.lib.extend (lfinal: lprev: {
            our = self.lib;
          });
        })
      ];

      supportedSystems = ["x86_64-linux" "aarch64-linux"];
    };
}
