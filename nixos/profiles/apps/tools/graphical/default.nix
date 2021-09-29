{ pkgs, lib, ... }: {
  environment.pathsToLink = [ "/share/ulauncher" ];

  environment.systemPackages = builtins.attrValues
    {
      inherit (pkgs)
        czkawka
        libnotify
        pywal
        ulauncher
        zathura
        ;
    }
  ++
  (lib.optionals
    (pkgs.system == "x86_64-linux")
    (with pkgs; [ etcher ]));
}
