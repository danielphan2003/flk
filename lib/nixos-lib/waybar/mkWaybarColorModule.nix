{lib}: templateCss: {type ? "span", ...} @ args: let
  inherit
    (builtins)
    attrNames
    attrValues
    removeAttrs
    ;

  inherit
    (lib)
    mapAttrs'
    nameValuePair
    replaceStrings
    ;

  removedArgs = removeAttrs args ["extraSubstituters"];

  substituters =
    (mapAttrs'
      (n: v: nameValuePair "@${n}@" v)
      removedArgs)
    // extraSubstituters;

  substitutersNames = attrNames substituters;

  substitutersValues = attrValues substituters;

  colorModule = replaceStrings substitutersNames substitutersValues templateCss;
in
  colorModule
