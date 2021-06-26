{ stdenv, lib, sources
, sassc, optipng, inkscape
, glib, gtk3, numix-icon-theme-circle, hicolor-icon-theme
}:
stdenv.mkDerivation rec {
  inherit (sources.whitesur-icon-theme) pname src version;

  buildInputs = [
    sassc
    optipng
    inkscape
    glib
    gtk3
  ];

  propagatedBuildInputs = [
    numix-icon-theme-circle
    hicolor-icon-theme
  ];

  postPatch = "patchShebangs .";

  installPhase = ''
    mkdir -p $out/share/icons
    ./install.sh -d $out/share/icons
  '';
}
