{ self, inputs, ... }:
let
  inherit (inputs) digga nixos nixos-hardware;
  inherit (builtins) attrValues;
in
{
  hostDefaults = {
    system = "x86_64-linux";
    channelName = "nixos";
    imports = [ (digga.lib.importExportableModules ./modules) ];
    modules = with inputs; [
      { lib.our = self.lib; }
      digga.nixosModules.bootstrapIso
      digga.nixosModules.nixConfig
      ci-agent.nixosModules.agent-profile
      home.nixosModules.home-manager
      ragenix.nixosModules.age
      bud.nixosModules.bud
      "${impermanence}/nixos.nix"
      qnr.nixosModules.local-registry
      nix-gaming.nixosModule
      ({ latestModulesPath, waydroidModulesPath, ... }: {
        imports = [
          "${latestModulesPath}/config/swap.nix"
          "${latestModulesPath}/config/xdg/portals/wlr.nix"
          "${latestModulesPath}/misc/extra-arguments.nix"
          "${latestModulesPath}/programs/xwayland.nix"
          "${latestModulesPath}/services/audio/spotifyd.nix"
          "${latestModulesPath}/services/networking/tailscale.nix"
          "${latestModulesPath}/services/security/vaultwarden/default.nix"
          "${latestModulesPath}/services/web-servers/caddy/default.nix"
          "${latestModulesPath}/tasks/filesystems.nix"
          "${waydroidModulesPath}/virtualisation/waydroid.nix"
        ];

        disabledModules = [
          "config/swap.nix"
          "misc/extra-arguments.nix"
          "programs/xwayland.nix"
          "services/audio/spotifyd.nix"
          "services/networking/tailscale.nix"
          "services/security/bitwarden_rs/default.nix"
          "services/web-servers/caddy.nix"
          "tasks/filesystems.nix"
        ];
      })
    ];
  };

  imports = [ (digga.lib.importHosts ./hosts) ];

  hosts = with nixos-hardware.nixosModules; {
    bootstrap = {
      tests = [ ];
    };
    NixOS = {
      tests = [ ];
    };
    pik2 = {
      system = "aarch64-linux";
      modules = [
        raspberry-pi-4
        {
          services.dnscrypt-proxy2.settings = {
            tls_cipher_suite = [ 52392 49199 ];
            max_clients = 10000;
          };
        }
      ];
      tests = [ ];
    };
    themachine = {
      modules = [
        common-cpu-amd
        common-gpu-amd
        common-pc-ssd
        {
          services.dnscrypt-proxy2.settings = {
            max_clients = 10000;
          };
        }
      ];
      tests = [ ];
    };
  };

  importables = rec {
    hostConfigs = let hostConfigs' = nixos.lib.importTOML ./hosts/hosts.toml; in
      hostConfigs' // {
        hosts = nixos.lib.mapAttrs
          (hostName: module: hostConfigs'.hosts."${hostName}" // {
            tailnet_domain = "${hostName}.${hostConfigs'.tailscale.tailnet_alias}";
            type = hostConfigs'.hosts."${hostName}".type or "permanant";
          })
          hostConfigs'.hosts;
      };

    profiles = digga.lib.rakeLeaves ./profiles // {
      users = digga.lib.rakeLeaves ../home/users;
    };

    suites = with profiles; rec {

      ### Profile suites

      base = attrValues {
        inherit (users) root;
        inherit (misc) security;
        inherit (shell) bash;
        inherit nix ssh;

        inherit (apps) base;
      };

      openBased = base ++ attrValues {
        inherit (shell) zsh;

        inherit (apps.tools) terminal;
        inherit (apps.editors) neovim;
      };

      ephemeralCrypt = attrValues {
        inherit (misc) persistence encryption;
      };

      networking = attrValues {
        inherit (network) networkd qos;
        inherit (network.dns) tailscale;
      };

      server = networking ++ attrValues {
        inherit (misc) disable-docs;
        inherit (virt) headless;
      };

      work = networking ++ attrValues {
        inherit (virt) headless minimal;
        inherit (apps) develop;
      };

      personal = attrValues {
        inherit (misc) peripherals;
      };

      graphics = work ++ attrValues {
        inherit (graphical) drivers qutebrowser;
        inherit (apps) gnome qt;
      };

      modern = graphics ++ attrValues {
        inherit (graphical) gtk pipewire greetd wayland misc;
      };

      legacy = graphics ++ attrValues {
        inherit (graphical) awesome picom;
        inherit (apps) x11;
      };

      producer = attrValues {
        inherit (apps) im;
        inherit (apps.chill) spotify;
      };

      mobile = attrValues {
        inherit laptop;
      };

      play = attrValues {
        inherit (graphical) gaming;
        inherit (network) chromecast;
        inherit (apps) wine;
      };

      goPlay = play ++ mobile;

      ### Host suites
      
      bootstrap = [ ]
        ++ openBased
        ++ networking
        ++ attrValues
        {
          inherit (users) nixos;
        };

      NixOS = bootstrap;

      pik2 = [ ]
        ++ openBased
        ++ ephemeralCrypt
        ++ server
        ++ attrValues
        {
          inherit (users) alita;
          inherit (graphical) pipewire;
          inherit (cloud)
            caddy
            # calibre-server
            grafana
            lvc-it-lib
            minecraft
            postgresql
            spotifyd
            vaultwarden
            ;
          inherit (apps) rpi;
          inherit (apps.tools)
            compression
            file-systems
          ;
        };

      themachine = [ ]
        ++ openBased
        ++ ephemeralCrypt
        ++ modern
        ++ personal
        ++ producer
        ++ play
        ++ attrValues
        {
          inherit (users) danie;
          inherit (cloud)
            aria2
            calibre-server
            netdata
            ;
          inherit (graphical.themes) sefia;
          inherit (misc) disable-mitigations gnupg;
          inherit (virt) windows;
          inherit (apps)
            meeting
            remote
            vpn
            ;
          inherit (apps.chill)
            reading
            watching
            weebs
            ;
          inherit (apps.tools)
            audio
            compression
            file-systems
            graphical
            ;
        };

    };
  };
}
