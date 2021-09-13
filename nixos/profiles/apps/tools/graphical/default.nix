{ pkgs, lib, ... }: {
  environment.systemPackages = builtins.attrValues
    {
      inherit (pkgs)
        czkawka
        libnotify
        pywal
        zathura
        ;
    }
  ++
  (lib.optionals
    (pkgs.system == "x86_64-linux")
    (with pkgs; [ etcher ]));
}
