{ pkgs, ... }: {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      adl
      anime-downloader
      trackma
      ;
  };
}
