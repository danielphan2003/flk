let
  inherit (cell) nixosProfiles nixosSuites;
in {
  base = [
    nixosProfiles.boot.systemd-boot.stage2
    nixosProfiles.fonts.minimal
    nixosProfiles.programs.base
    nixosProfiles.programs.nix
    nixosProfiles.programs.shells.bash
    nixosProfiles.security.hardened
  ];

  ephemeral-crypt = [
    nixosProfiles.system.persistence
    nixosProfiles.system.encryption.manual
  ];

  go-play = [
    nixosSuites.mobile
    nixosSuites.play
  ];

  graphics = [
    nixosProfiles.desktop.drivers
    nixosProfiles.programs.gnome
    nixosProfiles.programs.qt
    nixosProfiles.programs.qutebrowser
  ];

  insular = [
    nixosProfiles.virtualisation.container
    nixosProfiles.virtualisation.libvirt
  ];

  legacy =
    [
      nixosProfiles.desktop.window-managers.awesome
      nixosProfiles.gui.platforms.x11
    ]
    ++ nixosSuites.graphics;

  limitless =
    [
      nixosProfiles.users.nixos
      nixosProfiles.file-systems.base
    ]
    ++ nixosSuites.networking
    ++ nixosSuites.open-based;

  mobile = [nixosProfiles.hardware.laptop];

  modern =
    [
      nixosProfiles.desktop.pipewire
      nixosProfiles.gui.gtk
      nixosProfiles.gui.misc
      nixosProfiles.gui.platforms.wayland
    ]
    ++ nixosSuites.graphics;

  networking = [
    nixosProfiles.programs.networking
    nixosProfiles.networking.base
    nixosProfiles.networking.systemd-networkd
    nixosProfiles.networking.tailscale
  ];

  open-based =
    [
      nixosProfiles.programs.terminal
      nixosProfiles.programs.editors.neovim
      nixosProfiles.programs.shells.zsh
      nixosProfiles.services.base
      nixosProfiles.services.openssh
    ]
    ++ nixosSuites.base;

  personal = [
    nixosProfiles.fonts.fancy
    nixosProfiles.hardware.peripherals
  ];

  play = [
    nixosProfiles.desktop.gaming
    nixosProfiles.networking.chromecast
    nixosProfiles.programs.wine
  ];

  producer = [
    nixosProfiles.programs.im
    nixosProfiles.programs.chill.spotify
  ];

  server =
    [
      nixosProfiles.documentation.disabled
      nixosProfiles.virtualisation.container
    ]
    ++ nixosSuites.networking;
}
