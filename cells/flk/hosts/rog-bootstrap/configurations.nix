{
  inputs,
  cell,
}: {
  # target = "rog-bootstrap";
  system = "x86_64-linux";
  modules =
    Cells.nixos.users.root.nixos.modules.default ++
    Cells.nixos.users.alita.nixos.modules.default
    ;
}
