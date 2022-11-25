{
  themachine = {
    imports = [cell.nixosConfigurations.themachine];
    deployment.allowLocalDeployment = true;
  };
}
