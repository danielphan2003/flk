{lib, ...}: {
  imports = lib.our.getNixFiles ./.;
  nix.settings = {
    substituters = ["https://cache.nixos.org/"];
    trusted-public-keys = ["cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="];
  };
}
