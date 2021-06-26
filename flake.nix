{
  description = "A highly structured configuration database.";

  inputs =
    {
      nixos.url = "nixpkgs/release-21.05";
      latest.url = "nixpkgs";
      digga = {
        url = "github:divnix/digga/develop";
        inputs.nixpkgs.follows = "latest";
      };

      ci-agent = {
        url = "github:hercules-ci/hercules-ci-agent";
        inputs = { nix-darwin.follows = "darwin"; nixos-20_09.follows = "nixos"; nixos-unstable.follows = "latest"; };
      };
      darwin.url = "github:LnL7/nix-darwin";
      darwin.inputs.nixpkgs.follows = "latest";
      home.url = "github:nix-community/home-manager";
      home.inputs.nixpkgs.follows = "nixos";
      naersk.url = "github:nmattia/naersk";
      naersk.inputs.nixpkgs.follows = "latest";
      agenix.url = "github:nrdxp/agenix/yubikey";
      agenix.inputs.nixpkgs.follows = "latest";
      nixos-hardware.url = "github:nixos/nixos-hardware";

      nvfetcher.url = "github:berberman/nvfetcher";
      nvfetcher.inputs.nixpkgs.follows = "latest";

      firefox-nightly.url = "github:colemickens/flake-firefox-nightly/52035b6";
      firefox-nightly.inputs.nixpkgs.follows = "nixos";

      nixpkgs-wayland.url = "github:colemickens/nixpkgs-wayland/e5d15f8";
    };

  outputs =
    { self
    , digga
    , nixos
    , ci-agent
    , home
    , nixos-hardware
    , nur
    , agenix
    , nvfetcher
    , nixpkgs-wayland
    , firefox-nightly
    , ...
    } @ inputs:
    digga.lib.mkFlake {
      inherit self inputs;

      channelsConfig = { allowUnfree = true; };

      channels = {
        nixos = {
          imports = [ (digga.lib.importers.overlays ./overlays) ];
          overlays = [
            nur.overlay
            agenix.overlay
            nvfetcher.overlay
            ./pkgs/default.nix
            nixpkgs-wayland.overlay
            (final: prev: {
              firefox-nightly-bin =
                if prev.system == "x86_64-linux" then firefox-nightly.packages.${prev.system}.firefox-nightly-bin
                else { };
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

      nixos = {
        hostDefaults = {
          system = "x86_64-linux";
          channelName = "nixos";
          imports = [ (digga.lib.importers.modules ./modules) ];
          externalModules = [
            { lib.our = self.lib; }
            ci-agent.nixosModules.agent-profile
            home.nixosModules.home-manager
            agenix.nixosModules.age
          ];
        };

        imports = [ (digga.lib.importers.hosts ./hosts) ];
        hosts = {
          /* set host specific properties here */
          NixOS = { };
          pik2 = {
            system = "aarch64-linux";
            modules = [ nixos-hardware.nixosModules.raspberry-pi-4 ];
          };
          themachine = { };
        };
        importables = rec {
          profiles = digga.lib.importers.rakeLeaves ./profiles // {
            users = digga.lib.importers.rakeLeaves ./users;
          };
          suites = with profiles; rec {
            base = [ core users.root ];

            server = base ++ [ virt.headless ] ++ [
              network.networkmanager
              network.qos
            ];

            work = server ++ [ virt.minimal ] ++ [
              develop
            ];

            graphics = work ++ [ graphical ];

            mobile = graphics ++ [ laptop ];

            play = graphics ++ [
              # graphical.games
              network.torrent
              network.chromecast
              misc.disable-mitigations
            ];

            goPlay = play ++ [ laptop ];

            pik2 = server ++ [ users.alita ] ++ [
              # cloud.calibre-web
              cloud.grafana
              cloud.vaultwarden
              misc.encryption
              misc.persistence
              # network.stubby
            ];

            themachine = play ++ [ users.danie ] ++ [
              misc.encryption
              misc.persistence
            ];
          };
        };
      };

      home = {
        imports = [ (digga.lib.importers.modules ./users/modules) ];
        externalModules = [ ];
        importables = rec {
          profiles = digga.lib.importers.rakeLeaves ./users/profiles;
          suites = with profiles; rec {
            base = [ direnv git xdg auth ];

            desktop = base ++ [ firefox sway udiskie ];

            producer = desktop ++ [ obs-studio ];

            play = desktop ++ [ ];

            academic = play ++ [ winapps ];

            coding = academic ++ [ alacritty vscode-with-extensions ];

            alita = base;

            danie = coding;
          };
        };
      };

      devshell.externalModules = { pkgs, ... }: {
        commands = [
          { package = pkgs.agenix; category = "secrets"; }
          {
            name = pkgs.nvfetcher-bin.pname;
            help = pkgs.nvfetcher-bin.meta.description;
            command = "cd $DEVSHELL_ROOT/pkgs; ${pkgs.nvfetcher-bin}/bin/nvfetcher -c ./sources.toml --no-output $@; nixpkgs-fmt _sources/";
          }
        ];
      };

      homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;

      deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations { };

      defaultTemplate = self.templates.flk;
      templates.flk.path = ./.;
      templates.flk.description = "flk template";
    }
  ;
}
