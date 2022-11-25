{
  danie = {
    bee.home = inputs.home-unstable;
    bee.system = "x86_64-linux";
    bee.pkgs = inputs.cells.flk.pkgs.bootspec-nixpkgs;
    imports =
      [
        cell.homeSuites.danie
      ]
      ++ inputs.cells.home.homeModules.default
      ++ inputs.cells.home.homeModules.extra;
  };
}
