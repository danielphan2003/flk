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

  importables =
    let
      profiles = digga.lib.rakeLeaves ./profiles;

      suites = self.lib.importSuites ./suites {
        inherit (self) lib;
        inherit profiles;
      };
    in
    {inherit profiles suites;};

  users = {
    nixos = {...}: {};

    danie = {lib, profiles, suites, ...}: let
      gpgKey = "FA6FA2660BEC2464";
    in {
      imports = lib.our.mkSuite (import ./users/danie/suite.nix {inherit profiles suites;});

      programs.gpg.settings.default-key = gpgKey;

      programs.git = {
        userEmail = "danielphan.2003@c-137.me";

        userName = "Daniel Phan";

        signing = {
          key = gpgKey;
          signByDefault = true;
        };

        extraConfig.github.user = "danielphan2003";
      };

      home.sessionVariables.BROWSER = "chromium-browser";
    };

    alita = {...}: {};
  };
}
