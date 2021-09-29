{ self, inputs, ... }:
{
  modules = with inputs; [
    bud.devshellModules.bud
    # vs-ext.devshellModules.vs-ext
  ];
  exportedModules = [
    ./devos.nix
  ];
}
