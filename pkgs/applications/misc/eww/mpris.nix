{ stdenv
, lib
, writeScriptBin
, eww
, substituteAll
}:
let
  button = builtins.readFile ../../../../home/profiles/eww/config/templates/mpris/button.yuck;
  box = builtins.readFile ../../../../home/profiles/eww/config/templates/mpris/box.yuck;
in
stdenv.mkDerivation rec {
  pname = "eww-mpris";

  version = "0.1.0";

  src = writeScriptBin "eww-mpris"
    (builtins.readFile
      (substituteAll {
        src = ./mpris.py;
        inherit button box eww;
      }));

  dontBuild = true;

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    ln -s $src/bin/eww-mpris.py $out/bin/eww-mpris
  '';

  inherit (eww.meta) platforms;
}
