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
      agenix.nixosModules.age
      peerix.nixosModules.peerix
      qnr.nixosModules.local-registry
      ({ latestModulesPath, ... }: {
        imports = [ "${latestModulesPath}/virtualisation/waydroid.nix" ];
        disabledModules = [ "virtualisation/waydroid.nix" ];
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
          # inherit (graphical) pipewire;
          inherit (cloud)
            caddy
            # calibre-server
            grafana
            jitsi
            minecraft
            peerix
            postgresql
            # spotifyd
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
          # inherit (virt) windows;

          inherit (apps)
            develop
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
