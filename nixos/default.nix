{ self, inputs, ... }:
let
  inherit (inputs) digga;
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

  hosts = {
    bootstrap = {
      tests = [ ];
    };
    NixOS = {
      tests = [ ];
    };
    pik2 = {
      system = "aarch64-linux";
      modules = with inputs; [
        nixos-hardware.nixosModules.raspberry-pi-4
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
    profiles = removeAttrs (digga.lib.rakeLeaves ./profiles) [ "network.dns.common" ] // {
      users = digga.lib.rakeLeaves ../home/users;
    };

    suites = with profiles; rec {

      ### Profile suites

      base = attrValues {
        inherit core;
        inherit (users) root;
      };

      ephemeral-crypt = attrValues {
        inherit (misc) persistence encryption;
      };

      server = attrValues {
        inherit (network) networkd qos;
        inherit (network.dns) tailscale;
        inherit (virt) headless;
      };

      work = server ++ attrValues {
        inherit develop;
        inherit (virt) minimal;
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
        inherit (apps) im spotify;
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

      pik2 = [ ]
        ++ base
        ++ ephemeral-crypt
        ++ server
        ++ attrValues
        {
          inherit (users) alita;
          inherit (graphical) pipewire;
          inherit (misc) security;
          inherit (network.dns) dcompass;
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
          inherit (apps.tools) file-systems misc;
        };

      themachine = [ ]
        ++ base
        ++ ephemeral-crypt
        ++ modern
        ++ producer
        ++ play
        ++ attrValues
        ({
          inherit (users) danie;
          inherit (cloud)
            calibre-server
            netdata
            ;
          inherit (graphical.themes) sefia;
          inherit (misc) disable-mitigations security;
          inherit (network.dns) dcompass;
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
        } // apps.tools);

    };
  };
}
