{
  inputs,
  cell,
}: let
  nixpkgs = inputs.nixpkgs;
in {
  default = nixpkgs.writeShellScriptBin "repl" ''
    if [ -z "$1" ]; then
      nix repl --argstr host "$HOST" --argstr flakePath "$PRJ_ROOT" ${./repl/default.nix}
    else
      nix repl --argstr host "$HOST" --argstr flakePath $(readlink -f $1 | sed 's|/flake.nix||') ${./repl/default.nix}
    fi
  '';
}
