{ lib, pkgs }:
let
  inherit (builtins)
    removeAttrs
    replaceStrings
    substring
    toJSON
    ;

  inherit (lib)
    fileContents
    mapAttrs'
    nameValuePair
    ;

  motd = {}: {

    type = with lib.types; let
      valueType = nullOr
        (oneOf [
          bool
          int
          float
          str
          path
          (attrsOf valueType)
          (listOf valueType)
        ]) // {
        description = "JSON value";
      };
    in
    valueType;

    generate = value:
      (replaceStrings [ "\\\\" "\"" ] [ "\\" "" ]
        (fileContents
          (pkgs.runCommand "mc-motd"
            {
              nativeBuildInputs = [ pkgs.jq ];
              value = toJSON value;
              passAsFile = [ "value" ];
            } ''
            jq -r . "$valuePath" --ascii-output > $out
          '')));

  };

  colors = {
    black = ''\u00A70'';
    white = ''\u00A7f'';
    gold = ''\u00A76'';
    yellow = ''\u00A7e'';
    dark = {
      blue = ''\u00A71'';
      green = ''\u00A72'';
      aqua = ''\u00A73'';
      red = ''\u00A74'';
      purple = ''\u00A75'';
      gray = ''\u00A78'';
    };
    light = {
      blue = ''\u00A79'';
      green = ''\u00A7a'';
      aqua = ''\u00A7b'';
      red = ''\u00A7c'';
      purple = ''\u00A7d'';
      gray = ''\u00A77'';
    };
  };

  formats = rec {
    bold = ''\u00A7l'';
    underline = ''\u00A7n'';
    italic = ''\u00A7o'';
    strikethrough = ''\u00A7m'';
    obfuscated = ''\u00A7k'';
    reset = ''\u00A7r'';
  };

  short = typeMap: { prefix ? "", cut ? 1, isFunction ? false }: mapAttrs'
    (n: v:
      nameValuePair
        "${prefix}${
          if cut == -1 then n
          else substring 0 cut n}"
        (if isFunction then wrap: ''${v}${wrap}'' else v))
    typeMap;

  inherit (motd { }) generate;
in
{
  inherit colors generate;

  formats = short formats { cut = -1; isFunction = true; };

  gen = generate;

  c = (short (removeAttrs colors [ "dark" "light" ]) { })
    // (short colors.dark { prefix = "d_"; })
    // (short colors.light { prefix = "l_"; });

  f = short formats { cut = 2; isFunction = true; };
}
