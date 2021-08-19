{ pkgs, ... }: {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs.libsForQt5) qtstyleplugins;
    inherit (pkgs.qt5) qtgraphicaleffects;
  };
}
