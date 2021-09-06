{ lib
, spotify-unwrapped
, spicetify-cli
, spicetify-themes

, theme ? "SpicetifyDefault"
, colorScheme ? "green-dark"

, customApps ? { }
, customExtensions ? { }
, customThemes ? { }

, enabledCustomApps ? [ ]
, enabledExtensions ? [ ]

, injectCss ? false
, replaceColors ? false
, overwriteAssets ? false

, disableSentry ? true
, disableUiLogging ? true
, disableUpgradeCheck ? true
, exposeApis ? true

, removeRtlRule ? true

, spotifyLaunchFlags ? [ ]
}:
let
  inherit (lib) optionalString;
  helpers = import ./helpers.nix {
    inherit
      lib
      customApps
      customExtensions
      customThemes
      enabledCustomApps
      enabledExtensions
      spotifyLaunchFlags
      ;
  };
  inherit (helpers)
    boolToString
    spicetifyLnCommands
    extensionString
    customAppsString
    launchFlagsString
    optionalConfig
    ;
in
spotify-unwrapped.overrideAttrs (o: rec {
  pname = "spotify-spicified";

  nativeBuildInputs = o.nativeBuildInputs ++ [ spicetify-cli ];

  # Setup spicetify
  SPICETIFY_CONFIG = ".";

  postInstall = ''
    touch $out/prefs

    mkdir -p Themes Extensions CustomApps

    find ${spicetify-themes}/ -maxdepth 1 -type d -exec ln -s {} Themes \;

    ${spicetifyLnCommands}

    spicetify-cli config \
      prefs_path                      "$out/prefs" \
      spotify_path                    "$out/share/spotify" \
      inject_css                      ${boolToString injectCss} \
      replace_colors                  ${boolToString replaceColors} \
      overwrite_assets                ${boolToString overwriteAssets} \
      disable_sentry                  ${boolToString disableSentry} \
      disable_ui_logging              ${boolToString disableUiLogging} \
      disable_upgrade_check           ${boolToString disableUpgradeCheck} \
      expose_apis                     ${boolToString exposeApis} \
      remove_rtl_rule                 ${boolToString removeRtlRule} \
      ${optionalConfig "current_theme"        theme} \
      ${optionalConfig "color_scheme"         colorScheme} \
      ${optionalConfig "custom_apps"          customAppsString} \
      ${optionalConfig "extensions"           extensionString} \
      ${optionalConfig "spotify_launch_flags" launchFlagsString}

    spicetify-cli backup apply enable-devtool update -ne

    find CustomApps/ -maxdepth 1 -type d -exec cp {} $out/share/spotify/Apps \;
  '';

  meta = spotify-unwrapped.meta // {
    priority = (spotify-unwrapped.meta.priority or 0) - 1;
  };
})
