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
      base = attrValues {
        inherit
          direnv
          git
          xdg
          auth
          ;
      };

      desktop = base ++ (attrValues {
        inherit (browsers) firefox;
        inherit (browsers.exts) uget;
        inherit sway udiskie;
      });

      streaming = desktop ++ (attrValues {
        inherit obs-studio;
      });

      play = desktop ++ (attrValues {
        inherit (games) minecraft;
      });

      academic = play ++ (attrValues {
        inherit winapps;
      });

      coding = academic ++ (attrValues {
        inherit (browsers) chromium edge;
        inherit alacritty vscodium idea awesome eww neovim;
      });
    };
  };

  users = {
    nixos = { suites, ... }: { imports = suites.base; };

    danie = { suites, ... }:
      let
        gpgKey = "A3556DCE587353FB";
      in
      {
        imports = suites.coding;
        programs.gpg.settings.default-key = gpgKey;
        services.gpg-agent.sshKeys = [ "251E48ED4B7C2CC2C02828EBF7BE3592FC4ECA17" ];
        programs.git = {
          userEmail = "danielphan.2003@gmail.com";
          userName = "Daniel Phan";
          signing = {
            key = gpgKey;
            signByDefault = true;
          };
        };
        services.wayvnc.addr = "themachinix.duckdns.org";
        home.sessionVariables.BROWSER = "chromium-browser";
      };

    alita = { suites, ... }: {
      imports = suites.base;
      programs.git = {
        userEmail = "alita@pik2.duckdns.org";
        userName = "Alita";
      };
    };
  };
}
