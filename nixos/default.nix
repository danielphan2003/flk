{ self, inputs, ... }:
let
  inherit (inputs) digga nixos nixos-hardware;
  inherit (builtins) attrValues;
  inherit (self.lib) mkSuite;
in
{
  hostDefaults = {
    system = "x86_64-linux";
    channelName = "nixos";
    imports = [ (digga.lib.importExportableModules ./modules) ];
    modules = with inputs; [
      bud.nixosModules.bud
      ci-agent.nixosModules.agent-profile
      digga.nixosModules.bootstrapIso
      digga.nixosModules.nixConfig
      home.nixosModules.home-manager
      "${impermanence}/nixos.nix"
      nix-gaming.nixosModule
      ragenix.nixosModules.age
      peerix.nixosModules.peerix
      qnr.nixosModules.local-registry
      ({ config, pkgs, latestModulesPath, waydroidModulesPath, ... }: {
        imports = [
          "${latestModulesPath}/config/swap.nix"
          "${latestModulesPath}/config/xdg/portals/wlr.nix"
          "${latestModulesPath}/misc/extra-arguments.nix"
          "${latestModulesPath}/programs/xwayland.nix"
          "${latestModulesPath}/services/audio/spotifyd.nix"
          "${latestModulesPath}/services/networking/jibri/default.nix"
          "${latestModulesPath}/services/networking/jicofo.nix"
          "${latestModulesPath}/services/networking/jitsi-videobridge.nix"
          "${latestModulesPath}/services/networking/prosody.nix"
          "${latestModulesPath}/services/networking/tailscale.nix"
          "${latestModulesPath}/services/security/vaultwarden/default.nix"
          "${latestModulesPath}/services/web-apps/jitsi-meet.nix"
          "${latestModulesPath}/services/web-servers/caddy/default.nix"
          "${latestModulesPath}/tasks/filesystems.nix"
          "${waydroidModulesPath}/virtualisation/waydroid.nix"
        ];

        disabledModules = [
          "config/swap.nix"
          "misc/extra-arguments.nix"
          "programs/xwayland.nix"
          "services/audio/spotifyd.nix"
          "services/networking/jicofo.nix"
          "services/networking/jitsi-videobridge.nix"
          "services/networking/prosody.nix"
          "services/networking/tailscale.nix"
          "services/security/bitwarden_rs/default.nix"
          "services/web-apps/jitsi-meet.nix"
          "services/web-servers/caddy.nix"
          "tasks/filesystems.nix"
        ];

        lib.our = self.lib;

        services.lvm.package =
          if config.services.lvm.dmeventd.enable
          then pkgs.latest.lvm2_dmeventd
          else pkgs.latest.lvm2;
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

  importables =
    let
      hostConfigs = nixos.lib.importTOML ./hosts/hosts.toml;

      profiles = digga.lib.rakeLeaves ./profiles // {
        users = digga.lib.rakeLeaves ../home/users;
      };

      inherit (import ./suites { inherit (self) lib; inherit profiles; }) suites;

      inherit (profiles)
        apps
        cloud
        develop
        graphical
        laptop
        misc
        network
        nix
        shell
        ssh
        users
        virt
        ;
    in
    {
      inherit profiles;

      hostConfigs = nixos.lib.recursiveUpdate
        hostConfigs
        {
          hosts = nixos.lib.mapAttrs
            (hostName: module: {
              tailnet_domain = "${hostName}.${hostConfigs.tailscale.tailnet_alias}";
              type = hostConfigs.hosts."${hostName}".type or "permanant";
            })
            hostConfigs.hosts;
        };

      suites = suites // {
        bootstrap = suites.NixOS;

        pik2 = mkSuite {
          inherit (suites)
            openBased
            ephemeralCrypt
            server
            ;

          inherit (users) alita;
          inherit (graphical) pipewire;
          inherit (cloud)
            caddy
            # calibre-server
            grafana
            jitsi
            lvc-it-lib
            minecraft
            peerix
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

        themachine = mkSuite {
          inherit (suites)
            openBased
            ephemeralCrypt
            modern
            personal
            producer
            play
            ;

          inherit (users) danie;
          inherit (cloud)
            aria2
            calibre-server
            netdata
            peerix
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
