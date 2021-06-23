{ stdenv
, lib
, srcs
  # options
  # , gtk-engine-murrine
, sassc
, optipng
, inkscape
, glib
  # , libxml2
, alt ? "standard"
, theme ? "default"
, panel ? "default"
, size ? "default"
}:
let inherit (srcs) whitesur-gtk-theme; in
stdenv.mkDerivation rec {
  pname = "whitesur-gtk-theme";

  inherit (whitesur-gtk-theme) version;

  src = whitesur-gtk-theme;

  buildInputs = [
    # gtk-engine-murrine
    sassc
    optipng
    inkscape
    glib
    # libxml2
  ];

  postPatch = "patchShebangs .";

  installPhase = ''
    mkdir -p $out/share/themes
    ./install.sh -d $out/share/themes
  '';
}
