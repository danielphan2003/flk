{pkgs, ...}: {
  home.packages = builtins.attrValues {
    # desktop look & feel
    inherit
      (pkgs.gnome3)
      gnome-tweak-tool
      ;

    # extensions
    inherit
      (pkgs.gnomeExtensions)
      appindicator
      battery-status
      dash-to-dock
      ;
  };
}
