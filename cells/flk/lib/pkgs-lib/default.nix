{
  lib,
  pkgs,
}: {
  mc-motd = import ./mc-motd.nix {inherit lib pkgs;};
}
