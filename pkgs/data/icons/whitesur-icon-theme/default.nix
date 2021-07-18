{ stdenv
, lib
, sources
, sassc
, optipng
, inkscape
, glib
, gtk3
, numix-icon-theme-circle
, hicolor-icon-theme
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

  meta = with lib; {
    description = "MacOS Big Sur style icon theme for linux desktops";
    homepage = "https://github.com/vinceliuice/WhiteSur-icon-theme";
    license = licenses.gpl3;
    maintainers = [ danielphan2003 ];
    platforms = platforms.linux;
  };
}
