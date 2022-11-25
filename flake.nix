{
  description = "A highly structured configuration database.";
  # linters: nix
  inputs = {
    deadnix.url = "github:astro/deadnix";
    statix.url = "github:nerdypepper/statix";
  };

  # home
  inputs = {
    home.url = "github:nix-community/home-manager/release-22.05";
    home-unstable.url = "github:nix-community/home-manager";
  };

  # play-grounds
  # not responsible for any gulp gulp gulp.
  inputs = {
    # play-ground: Secure Boot
    bootspec-secureboot.url = "github:DeterminateSystems/bootspec-secureboot";
  };

  # packages
  inputs = {
    firefox-nightly.url = "github:colemickens/flake-firefox-nightly";

    fog.url = "github:danielphan2003/fog";

    hyprland.url = "github:hyprwm/Hyprland";

    hyprwm-contrib.url = "github:hyprwm/contrib";

    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs = {
        flake-compat.follows = "flake-compat";
        # lib-aggregate.follows = "lib-aggregate";
      };
    };

    rnix-lsp = {
      url = "github:nix-community/rnix-lsp";
      inputs = {
        naersk.follows = "naersk";
        utils.follows = "flake-utils";
      };
    };
  };

  # utils: agenix
  inputs = {
    agenix.follows = "ragenix";

    agenix-orig.url = "github:ryantm/agenix";

    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs = {
        agenix.follows = "agenix-orig";
        flake-utils.follows = "flake-utils";
        # rust-overlay.follows = "rust-overlay";
        naersk.follows = "naersk";
      };
    };
  };

  # utils: flake
  inputs = {
    colmena = {
      url = "github:zhaofengli/colmena";
      inputs = {
        flake-compat.follows = "flake-compat";
        utils.follows = "flake-utils";
      };
    };

    devos-ext-lib = {
      # url = "github:divnix/devos-ext-lib";
      url = "/home/danie/src/github.com/danielphan2003/devos-ext-lib";
      inputs.std.follows = "std";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs.flake-utils.follows = "flake-utils";
    };

    flake-utils-plus = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
      inputs.flake-utils.follows = "flake-utils";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixlib.follows = "nixlib";
    };

    qnr = {
      url = "github:divnix/quick-nix-registry";
      inputs.globalRegistry.follows = "flake-registry";
    };

    yants.url = "github:divnix/yants";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-registry = {
      url = "github:NixOS/flake-registry";
      flake = false;
    };
    # flake-utils.url = "github:numtide/flake-utils";
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    # nixlib.url = "github:nix-community/nixpkgs.lib";
  };

  # utils
  inputs = {
    coricamu = {
      url = "github:danth/coricamu";
      inputs.utils.follows = "flake-utils";
    };

    nvfetcher.url = "github:berberman/nvfetcher";

    nix2container.url = "github:nlewo/nix2container";
  };

  # toolchains
  inputs = {
    # toolchain: Go
    gomod2nix = {
      url = "github:tweag/gomod2nix";
      inputs.utils.follows = "flake-utils";
    };

    # toolchain: Nodejs
    npmlock2nix = {
      # url = "github:nix-community/npmlock2nix";
      url = "github:hlolli/npmlock2nix/lock/v2";
      flake = false;
    };

    # toolchain: Python
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.flake-utils.follows = "flake-utils";
    };

    # toolchain: Rust
    fenix.url = "github:nix-community/fenix";

    naersk.url = "github:nix-community/naersk";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  # configuration modules
  inputs = {
    digga.url = "github:divnix/digga";
    arkenfox-nixos.url = "github:dwarfmaster/arkenfox-nixos";

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.utils.follows = "digga/flake-utils-plus";
    };

    peerix = {
      url = "github:cid-chan/peerix";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
      };
    };

    stylix = {
      url = "github:danth/stylix";
      inputs = {
        coricamu.follows = "coricamu";
        home-manager.follows = "home";
        utils.follows = "flake-utils";
      };
    };
  };
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
    bootspec-nixpkgs.url =
      # "github:DeterminateSystems/nixpkgs";
      "github:ElvishJerricco/nixpkgs/bootspec-rfc-elvishjerricco";
    nixlib.url = "github:nix-community/nixpkgs.lib";
    flake-utils.url = "github:numtide/flake-utils";
  };

  # Std Inputs
  inputs = {
    std.url = "github:divnix/std";
    std.inputs.nixpkgs.follows = "nixpkgs-unstable";
    hive.url = "github:danielphan2003/hive/evalConfigArgs";
  };

  outputs = {
    self,
    std,
    hive,
    nixlib,
    ...
  } @ inputs: let
    evalConfigArgs = {
      specialArgs = {
        inherit (self) inputs;
        self = self.outPath;
        profiles = self.x86_64-linux.nixos.nixosProfiles;
        suites = self.x86_64-linux.nixos.nixosSuites;
        inherit (self.x86_64-linux.flk.pkgs.nixpkgs) lib;
      };
    };
  in
    std.growOn {
      inherit inputs;

      cellsFrom = ./cells;

      cellBlocks = with std.blockTypes; [
        # modules implement
        (functions "nixosModules")
        (functions "homeModules")
        (functions "devshellModules")

        # profiles activate
        (functions "hardwareProfiles")
        (functions "nixosProfiles")
        (functions "homeProfiles")
        (functions "devshellProfiles")

        # suites aggregate profiles
        (functions "nixosSuites")
        (functions "homeSuites")

        # configurations can be deployed
        (data "nixosConfigurations")
        (data "colmenaConfigurations")
        (data "homeConfigurations")
        (data "diskoConfigurations")

        (functions "overlays")
        (functions "nixpkgsConfig")
        (functions "packages")
        (functions "pkgs")

        # devshells can be entered
        (devshells "devshells")

        # jobs can be run
        (runnables "jobs")

        # library holds shared knowledge made code
        (functions "library")
      ];
    }
    {
      # ... with `nix develop` - `default` is a special target for `nix develop`
      devShells = std.harvest self ["flk" "devshells"];
      packages = std.harvest self ["flk" "packages"];
      pkgs = std.harvest self ["flk" "pkgs"];
    }
    {
      # tool: colmena -- "fill the jar on the soil with the honey!"
      colmenaHive = let
        makeHoneyFrom = import "${hive}/make-honey.nix" {
          inherit (inputs) colmena nixpkgs;
          cellBlock = "colmenaConfigurations";
          inherit evalConfigArgs;
        };
      in
        makeHoneyFrom self;

      # tool: nixos-generators -- "get drunk like a bear!"
      nixosConfigurations = let
        makeMeadFrom = import "${hive}/make-mead.nix" {
          inherit (inputs) nixpkgs;
          cellBlock = "nixosConfigurations";
          inherit evalConfigArgs;
        };
      in
        makeMeadFrom self;

      # tool: home-manager -- "drunken sailor, sunken sailor; honeymoon pantaloon."
      homeConfigurations = let
        makeMoonshineFrom = import "${hive}/make-moonshine.nix" {
          inherit (inputs) nixpkgs;
          cellBlock = "homeConfigurations";
        };
      in
        makeMoonshineFrom self;
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
