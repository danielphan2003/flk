{ lib, stdenv, flyingfox, rainfox, pywalfox }:
let
  inherit rainfox pywalfox;
  urlbar-blur = ./urlbar-blur.css;
  flyingfox-no-tabline = flyingfox.overrideAttrs (_: { patches = [ ./no-tabline.patch ]; });
in
stdenv.mkDerivation {
  pname = "interak";
  version = "0.0.1";

  installPhase = ''
    mkdir -p $out/chrome
    cp ${urlbar-blur} $out/chrome

    ln -s ${flyingfox-no-tabline}/chrome $out/chrome/flyingfox
    ln -s ${rainfox}/chrome $out/chrome/rainfox
    ln -s ${pywalfox}/chrome $out/chrome/pywalfox
  '';

  meta = with lib; {
    description = "An opinionated set of configurations for firefox";
    homepage = "https://interak.netlify.app";
    license = licenses.mit;
    maintainers = [ danielphan2003 ];
    platforms = platforms.all;
  };
}
