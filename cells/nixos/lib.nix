{
  inputs,
  cell,
}: let
  l = builtins // nixlib.lib // cells.flk.lib;
  inherit (inputs) cells nixlib;
in {
  mkNixosConfigurations = cells: let
    hosts = l.trim cells ["hosts"];
    inherit (cells) nixos;
    eachHosts = l.flip l.mapAttrs;
    outputBuilder = target: {
      configurations,
      modules ? {},
      profiles ? {},
      suites ? {},
    }: let
      hostConfig = l.mergeOn
        nixos.configurations
        {
          modules = nixos.modules.default ++ [
            {
              networking.hostName = configurations.target or target;
              # nixpkgs = {inherit (configurations) system;};
            }
          ] ++ l.flattenConfigs {inherit modules profiles suites;};
        }
        configurations
        ;

      otherArguments = l.removeAttrs hostConfig ["target" "channelName" "__functor"];
    in
      nixos.builders.default otherArguments;
  in
    eachHosts hosts outputBuilder;
}
