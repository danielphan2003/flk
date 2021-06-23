{ lib
, spicetify-cli-custom
, customApps
, customExtensions
, customThemes
, enabledCustomApps
, enabledExtensions
, injectCss
, overwriteAssets
, spotifyLaunchFlags
, replaceColors
, theme
}: with lib; rec {
  # inherit optionalString;

  # Helper functions
  pipeConcat = lists.foldr (a: b: a + "|" + b) "";
  lineBreakConcat = foldr (a: b: a + "\n" + b) "";
  boolToString = x: if x then "1" else "0";
  makeLnCommands = type:
    (attrsets.mapAttrsToList (name: path: "ln -sf ${path} ./${type}/${name}"));

  # Setup spicetify
  spicetify = "SPICETIFY_CONFIG=. ${spicetify-cli-custom}/bin/spicetify-cli";

  # Dribbblish is a theme which needs a couple extra settings
  isDribbblish = hasPrefix "Dribbblish" theme;

  extraCommands = (optionalString isDribbblish ''
    cp ./Themes/Dribbblish/dribbblish.js ./Extensions
  '') + (lineBreakConcat (makeLnCommands "Themes" customThemes))
  + (lineBreakConcat (makeLnCommands "Extensions" customExtensions))
  + (lineBreakConcat (makeLnCommands "CustomApps" customApps));

  customAppsFixupCommands =
    lineBreakConcat (makeLnCommands "Apps" customApps);

  injectCssOrDribbblish = boolToString (isDribbblish || injectCss);
  replaceColorsOrDribbblish = boolToString (isDribbblish || replaceColors);
  overwriteAssetsOrDribbblish = boolToString (isDribbblish || overwriteAssets);

  extensionString = pipeConcat
    ((optionals isDribbblish [ "dribbblish.js" ]) ++ enabledExtensions);

  customAppsString = pipeConcat enabledCustomApps;

  launchFlagsString = pipeConcat spotifyLaunchFlags;

  optionalConfig = config: value:
    optionalString (value != "") ''${config} "${value}"'';
}
