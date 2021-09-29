{ self, digga, nixos, ... }:
let inherit (self) nixosConfigurations; in
{
  nodes =
    let
      nodesInfo = nixos.lib.mapAttrs
        (host: module: { profiles.system.sshUser = "root"; })
        nixosConfigurations;
    in
    digga.lib.mkDeployNodes nixosConfigurations nodesInfo;
}
