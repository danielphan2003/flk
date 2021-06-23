let
  wrapOutput = k: v: { "\"${k}\"" = '' "${v}" ''; };

  defaultOutput =
    wrapOutput "text" "$TEXT" //
    wrapOutput "tooltip" "$TOOLTIP" //
    wrapOutput "class" "$CLASS" //
    wrapOutput "alt" "$ALT";

  modulePackage = path:
    { pkgs, overrides ? { }, output ? defaultOutput }:
      let
        module = pkgs.callPackage path overrides;
        inherit (module) name;
        inherit (pkgs) bash writeScript;
      in
      writeScript "${name}-waybar"
      ''
        #!/usr/bin/env ${bash}/bin/bash
        . ${module}
        echo -ne "${builtins.toJSON output}"
      '';
in modulePackage