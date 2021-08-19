{ pkgs, ... }: {
  home.packages = builtins.attrValues {
    inherit (pkgs)
      microsoft-edge-beta
      ;
  };
}
