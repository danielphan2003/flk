{
  inputs,
  cell,
}: let
  inherit (inputs) Cells;
in {
  # target = "themachine";
  system = "x86_64-linux";
  channelName = "bootspec-nixpkgs";

  modules =
    Cells.nixos.users.root.nixos.modules.default ++
    Cells.flk.users.danie.nixos.modules.default;
}
