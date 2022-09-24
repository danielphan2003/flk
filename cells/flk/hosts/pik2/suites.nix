{
  inputs,
  cell,
}: let
  inherit (inputs) Cells;
  nixosSuites = Cells.nixos.suites;
in {
  inherit
    (nixosSuites)
    ephemeral-crypt
    open-based
    server
  ;
}
