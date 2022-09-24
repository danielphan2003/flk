{
  lib,
  inputs
}: let
  l = lib // cells.std.lib;
  inherit (inputs) cells;
  inherit
    (l)
    flattenConfigs
    flip
    mapAttrs
    mergeOn
    trim
    ;
in {
  mkNixosConfigurations = self: let
    hosts = trim self ["hosts"];
    inherit (self) nixos;
  in
    mapAttrs (target: {
      configurations,
      modules ? {},
      profiles ? {},
      suites ? {},
    }: let
      final = mergeOn
        nixos.configurations
        {
          modules = nixos.modules.default ++ [
            {
              networking.hostName = configurations.target or target;
              # nixpkgs = {inherit (configurations) system;};
            }
          ] ++ flattenConfigs {inherit modules profiles suites;};
        }
        configurations
        ;
    in
      nixos.builders.default final) hosts;
}
