{ lib
, stdenv
, sources
, makeWrapper
, anime-downloader
, trackma
, fzf
, mpv
, withFrece ? true
, frece
, withUeberzug ? true
, ueberzug
}:

with lib;

stdenv.mkDerivation rec {
  inherit (sources.adl) pname src version;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    trackma
    anime-downloader
    fzf
    mpv
  ]
  ++ optional withFrece frece
  ++ optional withUeberzug ueberzug;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp adl $out/bin
    wrapProgram $out/bin/adl \
      --prefix PATH : ${makeBinPath buildInputs}
  '';

  meta = with lib; {
    homepage = "https://github.com/RaitaroH/adl";
    description = "popcorn anime-downloader + trackma wrapper";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.danielphan2003 ];
  };
}
