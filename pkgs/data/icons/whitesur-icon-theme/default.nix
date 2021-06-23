{ stdenv
, lib
, srcs
, sassc
, optipng
, inkscape
, glib
  # , libxml2
, gtk3
, numix-icon-theme-circle
  # , gnome3
, hicolor-icon-theme
}:
let inherit (srcs) whitesur-icon-theme; in
stdenv.mkDerivation rec {
  pname = "whitesur-icon-theme";

  inherit (whitesur-icon-theme) version;

  src = whitesur-icon-theme;

  buildInputs = [
    sassc
    optipng
    inkscape
    glib
    # libxml2
    gtk3
  ];

  propagatedBuildInputs = [
    numix-icon-theme-circle
    # gnome3.adwaita-icon-theme
    hicolor-icon-theme
  ];

  postPatch = "patchShebangs .";

  installPhase = ''
    mkdir -p $out/share/icons
    ./install.sh -d $out/share/icons
  '';
}
