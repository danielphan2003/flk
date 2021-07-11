{ lib, stdenv, flyingfox, rainfox, pywalfox }:
stdenv.mkDerivation rec {
  pname = "interak";
  version = "0.0.1";

  srcs = rec {
    inherit rainfox pywalfox;
    urlbar-blur = ./urlbar-blur.css;
    flyingfox = flyingfox.overrideAttrs (_: { patches = [ ./no-tabline.patch ]; });
  };

  installPhase = with srcs; ''
    mkdir -p $out/chrome
    cp ${urlbar-blur} $out/chrome

    ln -s ${flyingfox}/chrome $out/chrome/flyingfox
    ln -s ${rainfox}/chrome   $out/chrome/rainfox
    ln -s ${pywalfox}/chrome  $out/chrome/pywalfox
  '';

  meta = with lib; {
    description = "An opinionated set of configurations for firefox";
    homepage = "https://interak.netlify.app";
    license = licenses.mit;
    maintainers = [ danielphan2003 ];
    platforms = platforms.all;
  };
}
