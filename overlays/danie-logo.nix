final: prev: {
  danie-logo = prev.stdenv.mkDerivation rec {
    name = "danie-logo";
    src = ../home/users/danie/logo.png;
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/share/sddm/faces
      cp $src $out/share/sddm/faces/danie.face.icon
    '';
  };
}
