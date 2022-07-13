{
  self,
  inputs,
  ...
}: {
  nodes = let
    nodesInfo =
      inputs.nixos.lib.mapAttrs
      (host: module: {profiles.system.sshUser = "root";})
      self.nixosConfigurations;
  in
    inputs.digga.lib.mkDeployNodes self.nixosConfigurations nodesInfo;
}
