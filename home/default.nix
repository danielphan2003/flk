{
  self,
  inputs,
  ...
}: let
  inherit (inputs) digga;
  inherit (builtins) attrValues;
in {
  imports = [(digga.lib.importExportableModules ./modules)];

  modules = with inputs; [
    impermanence.nixosModules.home-manager.impermanence
  ];

  importables = rec {
    profiles = digga.lib.rakeLeaves ./profiles;
    suites = with profiles; rec {
      ### Profile suites

      ephemeral = attrValues {
        inherit (misc) xdg;
      };

      desktop = attrValues {
        inherit (browsers) firefox;
        inherit (graphical) sway;
        inherit (apps) udiskie uget;
      };

      streaming = attrValues {
        inherit (apps) obs-studio;
      };

      ### User suites

      danie =
        []
        ++ desktop
        ++ ephemeral
        ++ streaming
        ++ attrValues
        {
          inherit (browsers) chromium edge;
          inherit
            (develop)
            auth
            direnv
            git
            idea
            vscodium
            ;
          inherit (games) minecraft;
          inherit (graphical) awesome;
          inherit
            (apps)
            alacritty
            eww
            neovim
            winapps
            ;
        };
    };
  };

  users = {
    nixos = {...}: {};

    danie = {suites, ...}: let
      gpgKey = "FA6FA2660BEC2464";
    in {
      imports = suites.danie;
      programs.gpg.settings.default-key = gpgKey;
      programs.git = {
        userEmail = "danielphan.2003@c-137.me";
        userName = "Daniel Phan";
        signing = {
          key = gpgKey;
          signByDefault = true;
        };
        extraConfig = {
          github.user = "danielphan2003";
        };
      };
      home.sessionVariables.BROWSER = "chromium-browser";
    };

    alita = {...}: {};
  };
}
