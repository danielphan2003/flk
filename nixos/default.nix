{ self, inputs, ... }:
let
  inherit (inputs) digga;
  inherit (builtins) attrValues;
in
{
  hostDefaults = {
    system = "x86_64-linux";
    channelName = "nixos";
    imports = [ (digga.lib.importModules ./modules) ];
    externalModules = with inputs; [
      { lib.our = self.lib; }
      digga.nixosModules.bootstrapIso
      digga.nixosModules.nixConfig
      ci-agent.nixosModules.agent-profile
      home.nixosModules.home-manager
      agenix.nixosModules.age
      bud.nixosModules.bud
      "${impermanence}/nixos.nix"
      qnr.nixosModules.local-registry
      ({ latestModulesPath, ... }: {
        imports = [ "${latestModulesPath}/services/web-servers/caddy/default.nix" ];
        disabledModules = [ "services/web-servers/caddy.nix" ];
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
          services.dnscrypt-proxy2.settings.tls_cipher_suite = [ 52392 49199 ];
        }
      ];
      tests = [ ];
    };
    themachine = {
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

      server = base ++ (attrValues {
        inherit (network) networkd qos;
        inherit (network.dns) tailscale;
        inherit (virt) headless;
      });

      work = server ++ (attrValues {
        inherit develop;
        inherit (virt) minimal;
      });

      graphics = work ++ (attrValues {
        inherit (graphical) drivers qutebrowser;
        inherit (apps) gnome qt;
      });

      modern = graphics ++ (attrValues {
        inherit (graphical) gtk pipewire sddm wayland;
      });

      legacy = graphics ++ (attrValues {
        inherit (graphical) awesome picom;
        inherit (apps) x11;
      });

      producer = attrValues {
        inherit (apps) im spotify;
      };

      mobile = attrValues {
        inherit laptop;
      };

      play = attrValues {
        inherit (graphical) games;
        inherit (network) chromecast;
        inherit (apps) wine;
      };

      goPlay = play ++ mobile;

      ### Host suites

      pik2 = [ ]
        ++ ephemeral-crypt
        ++ server
        ++ attrValues
        {
          inherit (users) alita;
          inherit (misc) security;
          inherit (network.dns) dnscrypt-proxy;
          inherit (cloud)
            caddy
            minecraft
            netdata
            postgresql
            vaultwarden
            ;
          inherit (apps) rpi;
          inherit (apps.tools) file-systems misc;
        };

      themachine = [ ]
        ++ ephemeral-crypt
        ++ modern
        ++ producer
        ++ play
        ++ attrValues
        ({
          inherit (users) danie;
          inherit (cloud) netdata;
          inherit (graphical.themes) sefia;
          inherit (misc) disable-mitigations security;
          inherit (network.dns) dnscrypt-proxy;
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
