{ lib }:
let
  inherit (lib) forEach;

  appendString = string: list:
    forEach list (elem: string + elem);

in
{
  inherit appendString;
}