{ lib
, spicetify-cli-custom

, customApps
, customExtensions
, customThemes

, enabledCustomApps
, enabledExtensions

, spotifyLaunchFlags
}:
let inherit (lib) concatMapStrings concatStringsSep foldr mapAttrsToList optionalString; in
rec {
  # pipeConcat = concatStringsSep "|";
  # lineBreakConcat = concatMapStrings (x: x + "\n");
  pipeConcat = foldr (a: b: a + "|" + b) "";
  lineBreakConcat = foldr (a: b: a + "\n" + b) "";
  boolToString = x: if x then "1" else "0";
  makeLnCommands = type:
    mapAttrsToList (name: path: "ln -sf ${path} ./${type}/${name}");

  makeSpicetifyCommands = type: value:
    lineBreakConcat (makeLnCommands type value);

  # Setup spicetify
  spicetify = "SPICETIFY_CONFIG=. ${spicetify-cli-custom}/bin/spicetify-cli";

  extraCommands =
      makeSpicetifyCommands "Themes" customThemes
    + makeSpicetifyCommands "Extensions" customExtensions
    + makeSpicetifyCommands "CustomApps" customApps;

  customAppsFixupCommands = makeSpicetifyCommands "Apps" customApps;

  extensionString = pipeConcat enabledExtensions;

  customAppsString = pipeConcat enabledCustomApps;

  launchFlagsString = ''${pipeConcat spotifyLaunchFlags}'';

  optionalConfig = config: value:
    optionalString (value != "") ''${config} "${value}"'';
}
