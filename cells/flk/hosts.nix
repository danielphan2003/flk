{
  inputs,
  cell
}:
let
  l = builtins // nixlib.lib // cells.hive.lib;
  inherit (inputs) cells nixlib;
in
  l.importHosts {
    inherit inputs;
    hostsFrom = ./hosts;
  }
