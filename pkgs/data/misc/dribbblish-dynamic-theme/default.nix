{ lib, stdenv, sources }:
stdenv.mkDerivation rec {
  inherit (sources.dribbblish-dynamic-theme) pname src version;

  installPhase = ''
    mkdir -p $out/theme $out/extensions
    cp -r --parents assets/glue-resources/fonts user.css color.ini $out/theme
    cp Vibrant.min.js dribbblish-dynamic.js dribbblish.js $out/extensions
  '';

  meta = with lib; {
    description = "A mod of Dribbblish theme for Spicetify with support for light/dark modes and album art based colors.";
    homepage = "https://github.com/JulienMaille/dribbblish-dynamic-theme";
    maintainers = [ danielphan2003 ];
    platforms = platforms.all;
  };
}
