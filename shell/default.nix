{ self, inputs, ... }:
{
  externalModules = with inputs; [
    bud.devshellModules.bud
    # vs-ext.devshellModules.vs-ext
  ];
  modules = [
    ./devos.nix
  ];
}
