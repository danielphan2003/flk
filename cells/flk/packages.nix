let
  l = inputs.nixlib.lib;
in
  l.genAttrs ["nixpkgs" "nixos" "bootspec-nixpkgs"]
  (input:
    if inputs.${input} ? outPath
    then
      import inputs.${input} {
        inherit (cell.nixpkgsConfig) system config;
        overlays = [cell.overlays.default];
      }
    else inputs.${input}.extend cell.overlays.default)
