{
  inputs,
  cell,
}: let
  l = nixlib.lib // builtins;# // cell.lib;
  inherit (inputs) cells nixlib std;

  # Little hack, we make sure that `legacyPackages` contains `nix` to make sure that we are dealing with nixpkgs.
  # For some odd reason `devshell` contains `legacyPackages` out put as well
  filterChannels = l.filterAttrs (_: value: value ? legacyPackages && value.legacyPackages.x86_64-linux ? nix);

  channels = filterChannels inputs;

  packagesBuilder = cell.overlays.default;

  packages = l.mapAttrs (_: v: let
    pkgs = std.deSystemize system nixpkgs.legacyPackages;
  in packagesBuilder v v) channels;
in
  packages // packages.nixos
