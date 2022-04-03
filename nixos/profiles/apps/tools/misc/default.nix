{pkgs, ...}: {
  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      nix-index
      yubikey-manager-qt
      ;
  };
}
