{ python3
, lib
, wrapGAppsHook
, gobject-introspection
, glib
, playerctl
, eww
}:
python3.pkgs.buildPythonApplication {
  name = "eww-mpris";

  format = "other";

  src = ./mpris.py;

  dontUnpack = true;

  strictDeps = false;

  nativeBuildInputs = [
    wrapGAppsHook
    gobject-introspection
  ];

  buildInputs = [
    glib
    playerctl
  ];

  propagatedBuildInputs = [
    eww
    python3.pkgs.pygobject3
  ];

  installPhase = ''
    mkdir -p $out/bin $out/share/eww-mpris
    substitute $src $out/bin/eww-mpris --subst-var out
    chmod +x $out/bin/eww-mpris

    cp ${./box.yuck} $out/share/eww-mpris/box.yuck
    cp ${./button.yuck} $out/share/eww-mpris/button.yuck
  '';

  meta = with lib; {
    maintainers = with maintainers; [ danielphan2003 ];
  };
}
