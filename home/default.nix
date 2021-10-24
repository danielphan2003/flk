{ self, inputs, ... }:
let
  inherit (inputs) digga;
  inherit (builtins) attrValues;
in
{
  imports = [ (digga.lib.importExportableModules ./modules) ];

  modules = with inputs; [
    "${impermanence}/home-manager.nix"
  ];

  importables = rec {
    profiles = digga.lib.rakeLeaves ./profiles;
    suites = with profiles; rec {

      ### Profile suites

      ephemeral-identity = attrValues {
        inherit (develop) auth;
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

      danie = [ ]
        ++ desktop
        ++ ephemeral-identity
        ++ streaming
        ++ attrValues
        {
          inherit (browsers) chromium edge;
          inherit (develop)
            direnv
            git
            idea
            vscodium
            ;
          inherit (games) minecraft;
          inherit (graphical) awesome;
          inherit (apps)
            alacritty
            eww
            neovim
            winapps
            ;
        };
    };
  };

  users = {
    nixos = { ... }: { };

    danie = { suites, ... }:
      let
        gpgKey = "A3556DCE587353FB";
      in
      {
        imports = suites.danie;
        programs.gpg.settings.default-key = gpgKey;
        services.gpg-agent.sshKeys = [ "251E48ED4B7C2CC2C02828EBF7BE3592FC4ECA17" ];
        programs.git = {
          userEmail = "danielphan.2003@gmail.com";
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

    alita = { ... }: { };
  };
}
