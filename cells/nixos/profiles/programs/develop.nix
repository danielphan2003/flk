{
  lib,
  pkgs,
  profiles,
  ...
}: {
  imports = [profiles.programs.git];

  documentation.dev.enable = lib.mkDefault true;

  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      bc
      file
      gomod2nix
      less
      pmbootstrap
      tig
      tokei
      rnix-lsp
      ;
  };
}
