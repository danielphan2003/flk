{
  inputs,
  cell,
}: let
  homeSuites = inputs.Cells.home.suites;
in {
  inherit
    (homeSuites)
    desktop
    ephemeral
    streaming
    ;
}