{pkgs, ...}: {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs.gitAndTools) hub;
    inherit
      (pkgs)
      gh
      ghq
      git
      gitoxide
      gst
      lazygit
      ;
  };

  environment.shellAliases = {
    g = "git";
  };
}
