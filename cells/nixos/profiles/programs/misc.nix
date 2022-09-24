{pkgs, ...}: {
  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      nix-index
      revanced-cli
      ;
  };
}
