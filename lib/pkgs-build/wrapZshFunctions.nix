wrapper:
{ lib, pkgs, ... }:
pkgs.stdenv.mkDerivation rec {
  name = "zsh-functions";
  src = ./functions;

  installPhase =
    let basename = "\${file##*/}";
    in
    ''
      mkdir $out

      for file in $src/*; do
        substituteAll $file $out/${basename}
        chmod 755 $out/${basename}
      done
    '';
} // wrapper
