{
  rog-bootstrap = {
    imports = [cell.nixosConfigurations.rog-bootstrap];
    deployment = {
      targetHost = "fe80::47";
      targetPort = 22;
      targetUser = "root";
    };
  };
}
