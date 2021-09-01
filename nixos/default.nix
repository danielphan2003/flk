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
      qnr.nixosModules.local-registry
    ];
  };

  imports = [ (digga.lib.importHosts ./hosts) ];

  hosts = {
    bootstrap = { };
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

      ephemeral-crypt = with misc; [
        persistence
        encryption
      ];

      server = base
        ++
        [
          network.dns
          network.qos
          virt.headless
        ];

      work = server
        ++
        [
          network.networkmanager
          develop
          virt.minimal
        ];

      graphics = work
        ++
        [
          graphical.drivers
          graphical.qutebrowser
        ]
        ++
        (with apps; [
          gnome
          qt
        ]);

      modern = graphics
        ++
        (with graphical; [
          gtk
          pipewire
          sddm
          wayland
        ]);

      legacy = graphics
        ++
        (with graphical; [
          awesome
          picom
        ])
        ++
        (with apps; [
          x11
        ]);

      producer = with apps; [
        im
        spotify
      ];

      mobile = [ laptop ];

      play = [
        graphical.games
        network.chromecast
      ]
      ++
      (with apps; [
        wine
      ]);

      goPlay = play ++ mobile;

      ### Hosts

      pik2 = [ users.alita ]
        ++ ephemeral-crypt
        ++ server
        ++
        [
          cloud.caddy
          # cloud.calibre-web
          cloud.grafana
          cloud.minecraft
          cloud.postgresql
          cloud.vaultwarden
          # network.stubby
          network.tailscale
        ];

      themachine = [ users.danie ]
        ++ ephemeral-crypt
        ++ modern
        ++ producer
        ++ play
        ++
        [
          graphical.themes.sefia
          misc.disable-mitigations
          network.tailscale
        ]
        ++
        (with apps; [
          chill.reading
          chill.watching
          chill.weebs
          meeting
          tools
          vpn
        ]);
    };
  };
}
