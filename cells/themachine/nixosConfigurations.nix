{
  themachine = {
    bee.home = inputs.home-unstable;
    bee.system = "x86_64-linux";
    bee.pkgs = inputs.cells.flk.pkgs.bootspec-nixpkgs;
    # deployment.targetHost = "themachine";
    imports =
      [
        cell.nixosSuites.themachine
        inputs.cells.danie.nixosSuites.danie
        cell.hardwareProfiles.themachine
      ]
      ++ inputs.cells.nixos.nixosModules.default
      ++ inputs.cells.nixos.nixosModules.extra;
  };
}
