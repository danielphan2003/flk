{pkgs, ...}: {
  documentation.dev.enable = true;

  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      bc
      file
      gomod2nix
      lazygit
      less
      manix
      pmbootstrap
      tig
      tokei
      rnix-lsp
      ;
  };
}
