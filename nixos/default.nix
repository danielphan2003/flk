{ self, inputs, ... }:
let
  inherit (inputs) digga;
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
    ];
  };

  imports = [ (digga.lib.importHosts ./hosts) ];

  hosts = {
    NixOS = { };
    pik2 = {
      system = "aarch64-linux";
      modules = with inputs; [ nixos-hardware.nixosModules.raspberry-pi-4 ];
    };
    themachine = { };
  };

  importables = rec {
    profiles = digga.lib.rakeLeaves ./profiles // {
      users = digga.lib.rakeLeaves ../home/users;
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
        # network.torrent
        network.chromecast
        misc.disable-mitigations
      ];

      goPlay = play ++ [ laptop ];

      pik2 = server ++ [ users.alita ] ++ [
        # cloud.calibre-web
        cloud.grafana
        cloud.postgresql
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
}
