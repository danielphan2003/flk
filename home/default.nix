{ self, ... }:
let
  imp = self.inputs.digga.lib.importers;
in
{
  imports = [ (imp.modules ./modules) ];

  importables = rec {
    profiles = imp.rakeLeaves ./profiles;
    suites = with profiles; rec {

      base = [ direnv git xdg auth ];

      desktop = base ++ [ firefox sway udiskie ];

      producer = desktop ++ [ obs-studio ];

      play = desktop ++ [ ];

      academic = play ++ [ winapps ];

      coding = academic ++ [ alacritty vscode-with-extensions ];

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
          signing.key = gpgKey;
        };
      };

    alita = { suites, ... }:
      {
        imports = suites.base;
        programs.git = {
          userEmail = "alita@pik2.duckdns.org";
          userName = "Alita";
          signing.signByDefault = false;
        };
      };

  };
}