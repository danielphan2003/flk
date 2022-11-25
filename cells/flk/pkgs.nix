let
  l = inputs.nixlib.lib;
  overlays = l.attrValues cell.overlays;
in
  l.genAttrs ["nixpkgs" "nixos" "bootspec-nixpkgs"]
  (input:
    if inputs.${input} ? outPath
    then
      import inputs.${input} {
        inherit (cell.nixpkgsConfig) system config;
        inherit overlays;
      }
    else inputs.${input}.appendOverlays overlays)
