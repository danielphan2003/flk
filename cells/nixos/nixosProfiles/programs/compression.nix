{pkgs, ...}: {
  environment.systemPackages = let
    compressionCompat =
      if pkgs.system == "x86_64-linux"
      then {inherit (pkgs) ouch;}
      else {};

    compressionPkgs = {
      inherit
        (pkgs)
        bzip2
        gzip
        lrzip
        p7zip
        unrar
        unzip
        xz
        ;
    };
  in
    builtins.attrValues (compressionCompat // compressionPkgs);
}
