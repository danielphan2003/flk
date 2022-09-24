{
  inputs,
  cell,
}: let
  inherit (inputs) Cells;
in {
  # target = "pik2";
  system = "aarch64-linux";
  channelName = "nixos";
  
  # TODO: is `alita` needed anymore?
  modules =
    Cells.nixos.users.root.nixos.modules.default ++
    Cells.flk.users.alita.nixos.modules.default;
}
