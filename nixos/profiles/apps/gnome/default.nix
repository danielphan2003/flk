{ pkgs, ... }: {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs.gnome) file-roller nautilus;

    inherit (pkgs)
      gnome-themes-extra
      gtk-engine-murrine
      gtk_engines
      ;
  };
}
