{
  stdenv,
  lib,
  fog,
  # options
  # , gtk-engine-murrine
  sassc,
  optipng,
  inkscape,
  glib,
  # , libxml2
  alt ? "standard",
  theme ? "default",
  panel ? "default",
  size ? "default",
}:
stdenv.mkDerivation {
  inherit (fog.whitesur-gtk-theme) pname src version;

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
