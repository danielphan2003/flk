{
  lib,
  spotify-unwrapped,
  spicetify-cli,
  spicetify-themes,
  writeText,
  theme ? "SpicetifyDefault",
  colorScheme ? "green-dark",
  customApps ? {},
  customExtensions ? {},
  customThemes ? {},
  enabledCustomApps ? [],
  enabledExtensions ? [],
  injectCss ? false,
  replaceColors ? false,
  overwriteAssets ? false,
  disableSentry ? true,
  disableUiLogging ? true,
  disableUpgradeCheck ? true,
  exposeApis ? true,
  removeRtlRule ? true,
  commandLineArgs ? "",
  extraConfig ? "",
}: let
  inherit (lib) optionalString escapeShellArg escape;
  helpers = import ./helpers.nix {
    inherit
      lib
      customApps
      customExtensions
      customThemes
      enabledCustomApps
      enabledExtensions
      ;
  };
  inherit
    (helpers)
    boolToString
    spicetifyLnCommands
    extensionString
    customAppsString
    optionalConfig
    ;
  extraConfigFile = writeText "config.ini" extraConfig;
in
  spotify-unwrapped.overrideAttrs (o: {
    inherit extraConfigFile;

    pname = "spotify-spiced";

    nativeBuildInputs = o.nativeBuildInputs ++ [spicetify-cli];

    # Setup spicetify
    SPICETIFY_CONFIG = ".";

    prePatch = ''
      gappsWrapperArgs+=(
        --add-flags "${escapeShellArg commandLineArgs}"
      )
    '';

    postInstall = ''
      touch $out/prefs

      mkdir -p ./Themes ./Extensions ./CustomApps

      find ${spicetify-themes}/ -maxdepth 1 -type d -exec ln -s {} Themes \;

      ${spicetifyLnCommands}

      cat <<EOT >> "$SPICETIFY_CONFIG/$(spicetify-cli -c)"
      [Setting]
      prefs_path = $out/prefs
      spotify_path = $out/share/spotify
      EOT

      spicetify-cli config \
        inject_css                      ${boolToString injectCss} \
        replace_colors                  ${boolToString replaceColors} \
        overwrite_assets                ${boolToString overwriteAssets} \
        disable_sentry                  ${boolToString disableSentry} \
        disable_ui_logging              ${boolToString disableUiLogging} \
        disable_upgrade_check           ${boolToString disableUpgradeCheck} \
        expose_apis                     ${boolToString exposeApis} \
        remove_rtl_rule                 ${boolToString removeRtlRule} \
        ${optionalConfig "current_theme" theme} \
        ${optionalConfig "color_scheme" colorScheme} \
        ${optionalConfig "custom_apps" customAppsString} \
        ${optionalConfig "extensions" extensionString}

      cat $extraConfigFile >> "$SPICETIFY_CONFIG/$(spicetify-cli -c)"

      spicetify-cli backup apply

      find CustomApps/ -maxdepth 1 -type d -exec cp -r {} $out/share/spotify/Apps \;

      ln -sf $out/prefs $out/share/spotify/prefs
    '';

    meta =
      spotify-unwrapped.meta
      // {
        priority = (spotify-unwrapped.meta.priority or 0) - 1;
      };
  })
