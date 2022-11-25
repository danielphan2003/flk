{
  lib,
  inputs,
}: let
  l = lib;

  inherit
    (l)
    attrValues
    flattenTree'
    foldAttrs
    mergeAny
    recursiveUpdate
    removeAttrs
    types
    ;
in rec {
  flatAttrValues = pred: attrs: let
    flatAttrs = flattenTree' pred attrs;
  in
    attrValues flatAttrs;

  flattenModules = let
    type = with types;
      oneOf [
        path
        (functionTo attrs)
        # attrs
      ];
  in
    flatAttrValues type.check;

  flattenConfigs = {
    modules,
    profiles,
    suites,
  }: let
    prev = let
      flatSuites = attrValues suites;
    in
      foldAttrs recursiveUpdate {}
      (flatSuites ++ [profiles]);

    flatPrev = flattenModules prev;
    flatFinal = flattenModules modules;
  in
    flatPrev ++ flatFinal;
}
