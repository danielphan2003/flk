{
  inputs,
  cell,
}:
let
  l = builtins // nixlib.lib;
  inherit (inputs) nixlib;

  nixosProfiles = cell.profiles;
  nixosSuites = cell.suites;
in
  l.mapAttrs (_: v: l.foldl' l.recursiveUpdate {} (l.toList v)) {
    base = {
      boot = {inherit (nixosProfiles.boot) systemd-boot;};

      fonts = {inherit (nixosProfiles.fonts) minimal;};

      programs = {inherit (nixosProfiles.programs) base nix;};

      programs.shells = {inherit (nixosProfiles.programs.shells) bash;};

      security = {inherit (nixosProfiles.security) hardened;};
    };

    ephemeral-crypt = {
      system = {inherit (nixosProfiles.system) persistence encryption;};
    };

    go-play = [
      nixosSuites.mobile
      nixosSuites.play
    ];

    graphics = {
      desktop = {inherit (nixosProfiles.desktop) drivers;};

      programs = {inherit (nixosProfiles.programs) gnome qt qutebrowser;};
    };

    insular = {
      virtualisation = {inherit (nixosProfiles.virtualisation) container libvirt;};
    };

    legacy = [
      nixosSuites.graphics
      {
        desktop.window-managers = {inherit (nixosProfiles.desktop.window-managers) awesome;};

        gui.platforms = {inherit (nixosProfiles.gui.platforms) x11;};
      }
    ];

    limitless = [
      nixosSuites.networking
      nixosSuites.open-based
      {
        users = {inherit (nixosProfiles.users) nixos;};

        file-systems = {inherit (nixosProfiles.file-systems) base;};
      }
    ];

    mobile = {
      hardware = {inherit (nixosProfiles.hardware) laptop;};
    };

    modern = [
      nixosSuites.graphics
      {
        boot = {inherit (nixosProfiles.boot) plymouth;};

        desktop = {inherit (nixosProfiles.desktop) pipewire;};

        desktop.login-managers = {inherit (nixosProfiles.desktop.login-managers.greetd) tuigreet;};

        gui = {inherit (nixosProfiles.gui) gtk misc;};

        gui.platforms = {inherit (nixosProfiles.gui.platforms) wayland;};
      }
    ];

    networking = {
      programs = {inherit (nixosProfiles.programs) networking;};

      networking = {
        inherit
          (nixosProfiles.networking)
          base
          systemd-networkd
          tailscale
          ;
      };
    };

    open-based = [
      nixosSuites.base
      {
        programs = {inherit (nixosProfiles.programs) terminal;};

        programs.editors = {inherit (nixosProfiles.programs.editors) neovim;};

        programs.shells = {inherit (nixosProfiles.programs.shells) zsh;};

        services = {inherit (nixosProfiles.services) base openssh;};
      }
    ];

    personal = {
      fonts = {inherit (nixosProfiles.fonts) fancy;};

      hardware = {inherit (nixosProfiles.hardware) peripherals;};
    };

    play = {
      desktop = {
        inherit (nixosProfiles.desktop) gaming;
      };

      networking = {
        inherit (nixosProfiles.networking) chromecast;
      };

      programs = {
        inherit (nixosProfiles.programs) wine;
      };
    };

    producer = {
      programs = {
        inherit (nixosProfiles.programs) im;
      };

      programs.chill = {
        inherit (nixosProfiles.programs.chill) spotify;
      };
    };

    server = [
      nixosSuites.networking
      {
        documentation = {inherit (nixosProfiles.documentation) disabled;};
        virtualisation = {inherit (nixosProfiles.virtualisation) container;};
      }
    ];
  }
