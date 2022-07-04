{
  description = "A highly structured configuration database.";
  inputs.std.url = github:divnix/std;
  inputs.std.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nixpkgs.follows = "nixos-unstable";

  # tools
  inputs = {
    agenix = {
      url = github:yaxitech/ragenix;
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        rust-overlay.follows = "rust-overlay";
        naersk.follows = "naersk";
      };
    };

    deploy = {
      url = github:serokell/deploy-rs; # github:input-output-hk/deploy-rs;
      inputs = {
        nixpkgs.follows = "nixos";
        utils.follows = "flake-utils";
      };
    };

    devos-ext-lib = {
      url = github:danielphan2003/devos-ext-lib/other-extensions;
      # url = "/home/danie/src/github.com/danielphan2003/devos-ext-lib";
      inputs.nixpkgs.follows = "nixos";
    };

    digga = {
      url = github:divnix/digga;
      inputs = {
        nixpkgs.follows = "nixos";
        latest.follows = "nixpkgs";
        home-manager.follows = "home";
        deploy.follows = "deploy";
      };
    };

    flake-utils.url = "github:numtide/flake-utils";
    impermanence.url = github:nix-community/impermanence;
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    qnr.url = github:divnix/quick-nix-registry;
  };

  # nixpkgs & home-manager
  inputs = {
    nixos.follows = "nixos-22-05";
    home.follows = "home-22-05";
    # For darwin hosts: it can be helpful to track this darwin-specific stable
    # channel equivalent to the `nixos-*` channels for NixOS. For one, these
    # channels are more likely to provide cached binaries for darwin systems.
    # But, perhaps even more usefully, it provides a place for adding
    # darwin-specific overlays and packages which could otherwise cause build
    # failures on Linux systems.
    nixpkgs-darwin-stable.url = "github:NixOS/nixpkgs/nixpkgs-22.05-darwin";

    nixos-21-11.url = "nixpkgs/release-21.11";
    nixos-22-05.url = "nixpkgs/release-22.05";
    home-21-11.url = "github:nix-community/home-manager/release-21.11";
    home-22-05.url = "github:nix-community/home-manager/release-22.05";
    home-21-11.inputs.nixpkgs.follows = "nixos-21-11";
    home-22-05.inputs.nixpkgs.follows = "nixos-22-05";
    nixos-unstable.url = "nixpkgs/nixos-unstable";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-darwin-stable";

    dan-nixpkgs = {
      url = github:danielphan2003/nixpkgs;
      inputs = {
        nixpkgs.follows = "nixpkgs";
        std.follows = "std";
      };
    };

    nixpkgs-wayland = {
      url = github:nix-community/nixpkgs-wayland;
      inputs = {
        nixpkgs.follows = "nixpkgs";
        cachix.follows = "nixos";
      };
    };
  };

  # toolchains
  inputs = {
    # --- Go -------------------------------------------------------
    gomod2nix = {
      url = github:tweag/gomod2nix;
      inputs = {
        nixpkgs.follows = "nixos";
        utils.follows = "flake-utils";
      };
    };
    # --------------------------------------------------------------

    # --- Nodejs ---------------------------------------------------
    npmlock2nix = {
      # url = github:nix-community/npmlock2nix;
      url = github:mkhl/npmlock2nix/lock/v2;
      flake = false;
    };
    # --------------------------------------------------------------

    # --- Python ---------------------------------------------------
    poetry2nix = {
      url = github:nix-community/poetry2nix;
      inputs = {
        nixpkgs.follows = "nixos";
        flake-utils.follows = "flake-utils";
      };
    };

    # --- Rust -----------------------------------------------------
    fenix.url = github:nix-community/fenix;

    naersk = {
      url = github:nix-community/naersk;
      inputs.nixpkgs.follows = "nixos";
    };

    rust-overlay = {
      url = github:oxalica/rust-overlay;
      inputs = {
        nixpkgs.follows = "nixos";
        flake-utils.follows = "flake-utils";
      };
    };
    # --------------------------------------------------------------
  };

  # individual inputs
  inputs = {
    argonone-utils.url = github:danielphan2003/argonone-utils/flake-nixosModules;

    beautysh = {
      url = github:lovesegfault/beautysh;
      inputs = {
        nixpkgs.follows = "nixos";
        flake-utils.follows = "flake-utils";
        poetry2nix.follows = "poetry2nix";
      };
    };

    dcompass = {
      url = github:compassd/dcompass;
      inputs = {
        nixpkgs.follows = "nixos";
        utils.follows = "flake-utils";
        rust-overlay.follows = "rust-overlay";
      };
    };

    firefox-nightly = {
      url = github:colemickens/flake-firefox-nightly;
      inputs.nixpkgs.follows = "nixos";
    };

    hyprland = {
      url = "github:vaxerski/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    manix = {
      url = github:kreisys/manix;
      inputs = {
        nixpkgs.follows = "nixos";
        flake-utils.follows = "flake-utils";
      };
    };

    matrix-appservices.url = github:Pacman99/nixpkgs/matrix-appservices;

    nix-gaming = {
      url = github:fufexan/nix-gaming;
      inputs = {
        nixpkgs.follows = "nixos";
        utils.follows = "digga/flake-utils-plus";
      };
    };

    nixos-mailserver = {
      url = gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-21.11;
      inputs = {
        utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
        nixpkgs-21_11.follows = "nixos";
      };
    };

    nixos-mailserver-latest = {
      url = gitlab:simple-nixos-mailserver/nixos-mailserver;
      inputs = {
        utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
        nixpkgs-21_11.follows = "nixos";
      };
    };

    nvfetcher = {
      url = github:berberman/nvfetcher;
      inputs = {
        nixpkgs.follows = "nixos";
        flake-utils.follows = "flake-utils";
      };
    };

    peerix = {
      url = github:cid-chan/peerix;
      inputs = {
        nixpkgs.follows = "nixos";
        flake-utils.follows = "flake-utils";
      };
    };

    rnix-lsp = {
      url = github:nix-community/rnix-lsp;
      inputs = {
        nixpkgs.follows = "nixos";
        utils.follows = "flake-utils";
        naersk.follows = "naersk";
      };
    };
  };

  outputs = {
    self,
    std,
    # tools
    agenix,
    digga,
    devos-ext-lib,
    # toolchains
    gomod2nix,
    poetry2nix,
    fenix,
    naersk,
    rust-overlay,
    # nixpkgs & home-manager
    nixos,
    dan-nixpkgs,
    nixpkgs-wayland,
    # individual inputs
    dcompass,
    peerix,
    ...
  } @ inputs: let
    exports = ["x86_64-linux" "aarch64-linux"];
  in
    (digga.lib.mkFlake
      {
        inherit self inputs;

        channelsConfig = {allowUnfree = true;};

        channels = {
          nixos = {
            imports = [(digga.lib.importOverlays ./overlays)];
            overlays =
              [
                gomod2nix.overlays.default
                poetry2nix.overlay
                fenix.overlay
                naersk.overlay
                rust-overlay.overlay
                dcompass.overlay
                peerix.overlay
              ]
              ++ (builtins.attrValues devos-ext-lib.overlays)
              ++ [(import ./pkgs {inherit inputs;})];
          };
          nixpkgs = {
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

        supportedSystems = exports;
      })
    // (std.grow {
      inherit inputs;
      cellsFrom = ./cells;
      organelles = [
        (std.runnables "flkup")
        (std.runnables "repl")
        (std.functions "categories")
        (std.devshells "devshells")
      ];
      systems = exports;
    });

  # --- Flake Local Nix Configuration ----------------------------
  # TODO: adopt spongix
  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nrdxp.cachix.org"
      "https://nix-community.cachix.org"
      "https://dan-cfg.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "dan-cfg.cachix.org-1:elcVKJWjnDs1zzZ/Fs93FLOFS13OQx1z0TxP0Q7PH9o="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];
  };
  # --------------------------------------------------------------
}
