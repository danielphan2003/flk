{ lib }:
{ config, style, pywalPath, workspaces ? 15 }:
let
  inherit (builtins) toString;
  inherit (lib)
    nameValuePair fileContents
    flatten forEach genList imap0 remove
    concatImapStrings concatStringsSep optionalString
    mod replaceStrings splitString toInt
  ;
  
  bars = config.programs.waybar.settings;

  trimModule = module:
    concatStringsSep "-"
      (forEach
        (remove "sway" (splitString "/" module))
        (replaceStrings [ "#" ] [ "." ]));

  mergeModules = left: center: right:
    forEach 
      (genList (x: "sway/workspaces" ) (workspaces - 1) ++ left ++ center ++ right)
      trimModule;

  ifttt =
    cond:
    ifTrue:
    ifFalse:
    if cond
    then ifTrue
    else ifFalse;

  listToCss = list:
    concatImapStrings
      (pos: el: with el; ''
        #${ifttt (name == "workspaces") "sway-workspace-${toString pos}.focused" name} {
          background-color: @color${value};
        }
      '')
      list;
  
  toColor = x:
    toString (if x < 15 then x + 1 else mod x 16);

  mapColorToBar = bar: with bar;
    imap0
      (x: module: nameValuePair "${module}" "${toColor x}")
      (mergeModules modules-left modules-center modules-right);

  colors = listToCss
    (flatten (map mapColorToBar bars));
in ''
  @import url('file://${pywalPath}');
  ${colors}
  ${fileContents style}
''