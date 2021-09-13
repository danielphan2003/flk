{ pkgs, ... }: {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      pueue
      wgcf
      ydotool
      ;
  };
}
