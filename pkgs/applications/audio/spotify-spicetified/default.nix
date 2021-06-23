{ lib
, srcs
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
  spicetify-cli-custom = spicetify-cli { inherit legacySupport; };
  helpers = import ./helpers.nix {
    inherit
      lib
      spicetify-cli-custom
      customApps
      customExtensions
      customThemes
      enabledCustomApps
      enabledExtensions
      injectCss
      overwriteAssets
      spotifyLaunchFlags
      replaceColors
      theme;
  };
in
spotify-unwrapped.overrideAttrs (oldAttrs: rec {
  name = "spotify-spicified-${spotify-unwrapped.version}";

  postInstall = with helpers; ''
    touch $out/prefs

    mkdir Themes Extensions CustomApps

    find ${spicetify-themes}/ ${if legacySupport then "" else "${spicetify-cli-custom}/share/spicetify/Themes"} -maxdepth 1 -type d -exec ln -s {} Themes \;

    ls -la $out/share/spotify

    ${extraCommands}

    ${spicetify} config \
      spotify_path "$out/share/spotify" \
      prefs_path "$out/prefs" \
      inject_css                      ${injectCssOrDribbblish} \
      replace_colors                  ${replaceColorsOrDribbblish} \
      overwrite_assets                ${overwriteAssetsOrDribbblish} \
      disable_sentry                  ${boolToString disableSentry} \
      disable_ui_logging              ${boolToString disableUiLogging} \
      remove_rtl_rule                 ${boolToString removeRtlRule} \
      expose_apis                     ${boolToString exposeApis} \
      disable_upgrade_check           ${boolToString disableUpgradeCheck} \
      ${if legacySupport then '' \
        fastUser_switching            ${boolToString fastUserSwitching} \
        visualization_high_framerate  ${boolToString visualizationHighFramerate} \
        radio                         ${boolToString radio} \
        song_page                     ${boolToString songPage} \
        experimental_features         ${boolToString experimentalFeatures} \
        home                          ${boolToString home} \
        lyric_always_show             ${boolToString lyricAlwaysShow} \
        lyric_force_no_sync           ${boolToString lyricForceNoSync} \
      '' else ""} \
      ${optionalConfig "current_theme" theme} \
      ${optionalConfig "color_scheme" colorScheme} \
      ${optionalConfig "extensions" extensionString} \
      ${optionalConfig "custom_apps" customAppsString} \
      ${optionalConfig "spotify_launch_flags" launchFlagsString}

    ${spicetify} backup apply enable-devtool update -e

    cd $out/share/spotify

    ${customAppsFixupCommands}

  '';

  meta = spotify-unwrapped.meta // {
    priority = (spotify-unwrapped.meta.priority or 0) - 1;
  };
})

# ${spicetify} config \
#       spotify_path "$out/share/spotify" \
#       prefs_path "$out/prefs" \
#       inject_css                      ${injectCssOrDribbblish} \
#       replace_colors                  ${replaceColorsOrDribbblish} \
#       overwrite_assets                ${overwriteAssetsOrDribbblish} \
#       disable_sentry                  ${boolToString disableSentry} \
#       disable_ui_logging              ${boolToString disableUiLogging} \
#       remove_rtl_rule                 ${boolToString removeRtlRule} \
#       expose_apis                     ${boolToString exposeApis} \
#       disable_upgrade_check           ${boolToString disableUpgradeCheck} \
#       ${if legacySupport then '' \
#         fastUser_switching            ${boolToString fastUserSwitching} \
#         visualization_high_framerate  ${boolToString visualizationHighFramerate} \
#         radio                         ${boolToString radio} \
#         song_page                     ${boolToString songPage} \
#         experimental_features         ${boolToString experimentalFeatures} \
#         home                          ${boolToString home} \
#         lyric_always_show             ${boolToString lyricAlwaysShow} \
#         lyric_force_no_sync           ${boolToString lyricForceNoSync} \
#       '' else ""} \
#       ${optionalConfig "current_theme" theme} \
#       ${optionalConfig "color_scheme" colorScheme} \
#       ${optionalConfig "extensions" extensionString} \
#       ${optionalConfig "custom_apps" customAppsString} \
#       ${optionalConfig "spotify_launch_flags" launchFlagsString}

#     ${spicetify} backup apply enable-devtool update -e

# echo ${spicetify} config \
#       echo spotify_path "$out/share/spotify" \
#       echo prefs_path "$out/prefs" \
#       echo inject_css                      ${injectCssOrDribbblish} \
#       echo replace_colors                  ${replaceColorsOrDribbblish} \
#       echo overwrite_assets                ${overwriteAssetsOrDribbblish} \
#       echo disable_sentry                  ${boolToString disableSentry} \
#       echo disable_ui_logging              ${boolToString disableUiLogging} \
#       echo remove_rtl_rule                 ${boolToString removeRtlRule} \
#       echo expose_apis                     ${boolToString exposeApis} \
#       echo disable_upgrade_check           ${boolToString disableUpgradeCheck} \
#       echo ${if legacySupport then '' \
#         fastUser_switching            ${boolToString fastUserSwitching} \
#         visualization_high_framerate  ${boolToString visualizationHighFramerate} \
#         radio                         ${boolToString radio} \
#         song_page                     ${boolToString songPage} \
#         experimental_features         ${boolToString experimentalFeatures} \
#         home                          ${boolToString home} \
#         lyric_always_show             ${boolToString lyricAlwaysShow} \
#         lyric_force_no_sync           ${boolToString lyricForceNoSync} \
#       '' else ""} \
#       echo ${optionalConfig "current_theme" theme} \
#       echo ${optionalConfig "color_scheme" colorScheme} \
#       echo ${optionalConfig "extensions" extensionString} \
#       echo ${optionalConfig "custom_apps" customAppsString} \
#       echo ${optionalConfig "spotify_launch_flags" launchFlagsString} \
#     echo ${spicetify} backup apply enable-devtool update -e
