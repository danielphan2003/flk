{ pkgs, ... }: {
  environment.systemPackages = builtins.attrValues
    (if pkgs.system != "aarch64-linux"
    then
      {
        inherit (pkgs) ouch;
      }
    else
      {
        inherit (pkgs)
          bzip2
          gzip
          lrzip
          p7zip
          unrar
          unzip
          xz
          ;
      });
}
