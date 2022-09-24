{
  inputs,
  cell,
}: let
  l = builtins // nixlib.lib;
  inherit (inputs) nixlib nixpkgs;
in {
  nixpkgs = {};
  nixos = {};

  bootspec-nixpkgs = {
    input = nixpkgs;
    patches = [cell.patches.bootspec-rfc];
  };
}
