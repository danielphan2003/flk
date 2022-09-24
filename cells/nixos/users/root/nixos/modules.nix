{
  inputs,
  cell,
}: let
  l = builtins // nixlib.lib // digga.lib;
  inherit (inputs) digga nixlib;

  modules = l.rakeLeaves ./modules;
  flatModules = l.flattenTree modules;
in
  modules // {default = l.attrValues flatModules;}
