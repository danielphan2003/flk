{ pkgs, ... }: {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      protonvpn-cli
      ;
  };
}
