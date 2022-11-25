{
  pik2 = {
    bee.home = inputs.home-unstable;
    bee.system = "aarch64-linux";
    bee.pkgs = inputs.cells.flk.pkgs.nixos;
    imports =
      [
        cell.nixosSuites.pik2
      ]
      ++ inputs.cells.nixos.nixosModules.default
      ++ inputs.cells.nixos.nixosModules.extra;
  };
}
