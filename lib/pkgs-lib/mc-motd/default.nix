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

    generate = value: let
      mc-motd = pkgs.latest.runCommand "mc-motd" {
        nativeBuildInputs = [ pkgs.jq ];
        value = toJSON value;
        passAsFile = [ "value" ];
      } ''
        jq -rj . "$valuePath" --ascii-output > $out
      '';
    in replaceStrings [ "\"" ] [ "" ] (fileContents mc-motd);

  };

  colors = {
    black = "0";
    white = "f";
    gold = "6";
    yellow = "e";
    dark = {
      blue = "1";
      green = "2";
      aqua = "3";
      red = "4";
      purple = "5";
      gray = "8";
    };
    light = {
      blue = "9";
      green = "a";
      aqua = "b";
      red = "c";
      purple = "d";
      gray = "7";
    };
  };

  formats = {
    bold = "l";
    underline = "n";
    italic = "o";
    strikethrough = "m";
    obfuscated = "k";
    reset = "r";
  };

  short = typeMap: { prefix ? "", cut ? 1, isFunction ? false }: mapAttrs'
    (n: v:
      nameValuePair
        "${prefix}${
          if cut == -1 then n
          else substring 0 cut n}"
        (if isFunction then wrap: "§${v}${wrap}" else "§${v}"))
    typeMap;

  inherit (motd { }) generate;
in
{
  inherit generate;

  colors = short colors { cut = -1; };

  formats = short formats { cut = -1; isFunction = true; };

  gen = generate;

  c = (short (removeAttrs colors [ "dark" "light" ]) { })
    // (short colors.dark { prefix = "d_"; })
    // (short colors.light { prefix = "l_"; });

  f = short formats { cut = 2; isFunction = true; };
}
