{ lib, profiles }:
let
  inherit (lib) mkSuite;
  inherit (builtins) attrValues;

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

  suites =
    let
      base = attrValues {
        inherit (users) root;
        inherit (misc) security;
        inherit (shell) bash;
        inherit nix ssh;

        inherit (apps) base;
        inherit (apps.fonts) minimal;
      };

      ephemeralCrypt = attrValues {
        inherit (misc) persistence encryption;
      };

      graphics = mkSuite {
        inherit work;

        inherit (graphical) drivers qutebrowser;
        inherit (apps) gnome qt;
      };

      networking = attrValues {
        inherit (network) networkd qos;
        inherit (network.dns) tailscale;
      };

      personal = attrValues {
        inherit (misc) peripherals;
        inherit (apps.fonts) fancy;
      };

      producer = attrValues {
        inherit (apps) im;
        inherit (apps.chill) spotify;
      };

      mobile = attrValues {
        inherit laptop;
      };

      openBased = mkSuite {
        inherit base;

        inherit (shell) zsh;

        inherit (apps.tools) terminal;
        inherit (apps.editors) neovim;
      };

      play = attrValues {
        inherit (graphical) gaming;
        inherit (network) chromecast;
        inherit (apps) wine;
      };

      work = mkSuite {
        inherit networking;

        inherit (virt) headless minimal;
      };
    in
    {
      inherit base ephemeralCrypt networking openBased personal producer mobile play work;

      goPlay = mkSuite { inherit mobile play; };

      NixOS = mkSuite {
        inherit
          openBased
          networking
          ;

        inherit (users) nixos;
      };

      legacy = mkSuite {
        inherit graphics;

        inherit (graphical) awesome picom;
        inherit (apps) x11;
      };

      modern = mkSuite {
        inherit graphics;

        inherit (graphical) gtk pipewire greetd wayland misc;
      };

      server = mkSuite {
        inherit networking;

        inherit (misc) disable-docs;
        inherit (virt) headless;
      };
    };
in
{ inherit suites; }
