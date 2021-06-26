{ lib
, spotify-unwrapped
, spicetify-cli
, spicetify-themes

, legacySupport ? false

  # Spicetify settings
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

, spotifyLaunchFlags ? [ ]

, disableSentry ? true
, disableUiLogging ? true
, disableUpgradeCheck ? true
, exposeApis ? true

, experimentalFeatures ? false
, fastUserSwitching ? false
, home ? false
, lyricAlwaysShow ? false
, lyricForceNoSync ? false
, radio ? false
, removeRtlRule ? true
, songPage ? false
, visualizationHighFramerate ? false
}:
let
  inherit (lib) optionalString;
  spicetify-cli-custom = spicetify-cli.overrideAttrs (o: { inherit legacySupport; });
  spotify-custom = spotify-unwrapped.overrideAttrs (o: { inherit legacySupport; });
  helpers = import ./helpers.nix {
    inherit
      lib
      spicetify-cli-custom
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
    spicetify
    extraCommands
    customAppsFixupCommands
    extensionString
    customAppsString
    launchFlagsString
    optionalConfig
  ;
  legacyConfigs = optionalString legacySupport '' \
    fastUser_switching            ${boolToString fastUserSwitching} \
    visualization_high_framerate  ${boolToString visualizationHighFramerate} \
    radio                         ${boolToString radio} \
    song_page                     ${boolToString songPage} \
    experimental_features         ${boolToString experimentalFeatures} \
    home                          ${boolToString home} \
    lyric_always_show             ${boolToString lyricAlwaysShow} \
    lyric_force_no_sync           ${boolToString lyricForceNoSync}
  '';
in
spotify-custom.overrideAttrs (oldAttrs: rec {
  name = "spotify-spicified-${spotify-custom.version}";

  postInstall = ''
    touch $out/prefs

    mkdir -p Themes Extensions CustomApps

    find ${spicetify-themes}/ -maxdepth 1 -type d -exec ln -s {} Themes \;

    ls -la
    ls -la ${spicetify-themes}

    echo ${extraCommands}

    ${extraCommands}

    ${spicetify} config \
      spotify_path                    "$out/share/spotify" \
      prefs_path                      "$out/prefs" \
      inject_css                      ${boolToString injectCss} \
      replace_colors                  ${boolToString replaceColors} \
      overwrite_assets                ${boolToString overwriteAssets} \
      disable_sentry                  ${boolToString disableSentry} \
      disable_ui_logging              ${boolToString disableUiLogging} \
      remove_rtl_rule                 ${boolToString removeRtlRule} \
      expose_apis                     ${boolToString exposeApis} \
      disable_upgrade_check           ${boolToString disableUpgradeCheck} \
      ${optionalConfig "current_theme"        theme} \
      ${optionalConfig "color_scheme"         colorScheme} \
      ${optionalConfig "extensions"           extensionString} \
      ${optionalConfig "custom_apps"          customAppsString} \
      ${optionalConfig "spotify_launch_flags" launchFlagsString} \
      ${legacyConfigs}

    ${spicetify} -c

    cat config-xpui.ini

    ${spicetify} backup apply enable-devtool update -ne

    cd $out/share/spotify

    ${customAppsFixupCommands}
  '';

  meta = spotify-custom.meta // {
    priority = (spotify-custom.meta.priority or 0) - 1;
  };
})