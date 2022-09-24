{
  inputs,
  cell,
}:
let
  l = builtins // nixlib.lib;
  inherit (inputs) nixlib;

  homeProfiles = cell.profiles;
  homeSuites = cell.suites;
in
  l.mapAttrs (_: v: l.foldl' l.recursiveUpdate {} (l.toList v)) {
    desktop = {
      desktop = {inherit (homeProfiles.desktop) xdg;};

      gui = {inherit (homeProfiles.gui) gtk;};

      services = {
        inherit
          (homeProfiles.services)
          udiskie
          ;
      };
    };

    ephemeral = {
      desktop = {inherit (homeProfiles.desktop) xdg;};

      # dead hard drive lmao
      # misc = {inherit (homeProfiles.misc) persistence;};
    };

    streaming = {
      programs = {inherit (homeProfiles.programs) obs-studio;};
    };
  }
