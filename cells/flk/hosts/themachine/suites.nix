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
    insular
    networking
    open-based
    modern
    personal
    play
    producer
    ;
}
