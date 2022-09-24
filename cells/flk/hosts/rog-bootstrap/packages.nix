{
  inputs,
  cell
}:
let
  l = builtins // nixlib.lib;
  inherit (inputs) nixlib nixos-generators;

  nixosGenerate = format: args: let
    args' = l.recursiveUpdate {
      inherit format;
    } args;
  in
    nixos-generators.nixosGenerate args';
in
  l.mapAttrs nixosGenerate {
    bootstrap-iso = cell.configurations.nixos;
  }
