{pkgs, ...}: {
  programs.file-roller.enable = true;

  services.gnome.sushi.enable = true;

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs.gnome) nautilus;

    inherit
      (pkgs)
      gnome-themes-extra
      gtk-engine-murrine
      gtk_engines
      ;
  };
}
