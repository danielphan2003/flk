{ pkgs, ... }: {
  xdg.configFile.".river/init".source = pkgs.callPackage ./config { };
  xdg.configFile.".river/layout".source = pkgs.callPackage ./layout { };
}
