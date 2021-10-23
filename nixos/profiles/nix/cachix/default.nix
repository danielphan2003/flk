{ lib, ... }: {
  imports = lib.our.getNixFiles ./.;
  nix = {
    binaryCaches = [ "https://cache.nixos.org/" ];
    binaryCachePublicKeys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
  };
}
