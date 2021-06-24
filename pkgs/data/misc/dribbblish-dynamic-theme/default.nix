{ lib, stdenv, srcs }:
let inherit (srcs) dribbblish-dynamic-theme; in
stdenv.mkDerivation rec {
  pname = "dribbblish-dynamic-theme";

  inherit (dribbblish-dynamic-theme) version;
  src = dribbblish-dynamic-theme;

  installPhase = ''
    mkdir -p $out/theme $out/extensions
    cp user.css color.ini $out/theme
    cp -r --parents assets/glue-resources/fonts $out/theme
    cp Vibrant.min.js dribbblish-dynamic.js dribbblish.js $out/extensions
  '';

  meta = with lib; {
    description = "A mod of Dribbblish theme for Spicetify with support for light/dark modes and album art based colors.";
    homepage = "https://github.com/JulienMaille/dribbblish-dynamic-theme";
    maintainers = with maintainers; [ danielphan2003 ];
    platforms = platforms.all;
  };
}
