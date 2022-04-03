{
  lib,
  stdenv,
  sources,
  python3Packages,
  withGtk ? true,
  wrapGAppsHook,
  glib,
  gobject-introspection,
  gtk3,
  withQt ? true,
  pillow ? python3Packages.pillow,
  withCurses ? true,
  withMpris ? true,
}: let
  inherit (lib) optionals optionalString;
in
  with python3Packages;
    buildPythonApplication rec {
      inherit (sources.trackma) pname src version;

      nativeBuildInputs =
        []
        ++ optionals withGtk [wrapGAppsHook];

      buildInputs =
        []
        ++ optionals withGtk [glib gobject-introspection gtk3];

      propagatedBuildInputs =
        [urllib3]
        ++ optionals withQt [pyqt5]
        ++ optionals withGtk [pygobject3 pycairo]
        ++ optionals withCurses [urwid]
        ++ optionals stdenv.isLinux [pyinotify]
        ++ optionals withMpris [dbus-python]
        ++ optionals (withGtk || withQt) [pillow];

      strictDeps = false; # broken with gobject-introspection setup hook, see https://github.com/NixOS/nixpkgs/issues/56943
      dontWrapGApps = true; # prevent double wrapping

      preFixup = ''
        makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
      '';

      # No tests included
      doCheck = false;
      pythonImportsCheck = ["trackma"];

      postDist = ''
        ${optionalString (!withQt) "rm $out/bin/trackma-qt"}
        ${optionalString (!withGtk) "rm $out/bin/trackma-gtk"}
        ${optionalString (!withCurses) "rm $out/bin/trackma-curses"}
      '';

      meta = with lib; {
        homepage = "https://github.com/z411/trackma";
        description = "Open multi-site list manager for Unix-like systems. (ex-wMAL)";
        license = licenses.gpl3;
        platforms = ["x86_64-linux"];
        maintainers = [maintainers.danielphan2003];
      };
    }
