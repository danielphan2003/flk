{
  lib,
  hyprland-unwrapped,
  makeWrapper,
  symlinkJoin,
  writeShellScriptBin,
  withBaseWrapper ? true,
  extraSessionCommands ? "",
  dbus,
  withGtkWrapper ? true,
  wrapGAppsHook,
  gdk-pixbuf,
  glib,
  gtk3,
  extraOptions ? [], # E.g.: [ "--verbose" ]
  dbusSupport ? true,
  debug ? false,
  enableXWayland ? true,
  legacyRenderer ? false,
  version ? "git",
}:
assert extraSessionCommands != "" -> withBaseWrapper;
with lib; let
  hyprland = hyprland-unwrapped.override {inherit debug enableXWayland legacyRenderer version;};

  baseWrapper = writeShellScriptBin "Hyprland" ''
    set -o errexit

    if [ ! "$_HYPRLAND_WRAPPER_ALREADY_EXECUTED" ]; then
      export XDG_CURRENT_DESKTOP=Hyprland
      ${extraSessionCommands}
      export _HYPRLAND_WRAPPER_ALREADY_EXECUTED=1
    fi

    if [ "$DBUS_SESSION_BUS_ADDRESS" ]; then
      export DBUS_SESSION_BUS_ADDRESS
      exec ${hyprland}/bin/Hyprland "$@"
    else
      exec ${optionalString dbusSupport "${dbus}/bin/dbus-run-session"} ${hyprland}/bin/Hyprland "$@"
    fi
  '';
in
  symlinkJoin {
    name = "hyprland-${hyprland.version}";

    paths =
      (optional withBaseWrapper baseWrapper)
      ++ [hyprland];

    strictDeps = false;
    nativeBuildInputs =
      [makeWrapper]
      ++ (optional withGtkWrapper wrapGAppsHook);

    buildInputs = optionals withGtkWrapper [gdk-pixbuf glib gtk3];

    # We want to run wrapProgram manually
    dontWrapGApps = true;

    postBuild = ''
      ${optionalString withGtkWrapper "gappsWrapperArgsHook"}

      wrapProgram $out/bin/Hyprland \
        ${optionalString withGtkWrapper ''"''${gappsWrapperArgs[@]}"''} \
        ${optionalString (extraOptions != []) "${concatMapStrings (x: " --add-flags " + x) extraOptions}"}
    '';

    passthru.providedSessions = ["hyprland"];

    inherit (hyprland) meta;
  }
