final: prev: {
  danie-logo = prev.stdenv.mkDerivation {
    name = "danie-logo";
    src = ../users/danie/logo.png;
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/share/sddm/faces
      cp $src $out/share/sddm/faces/danie.face.icon
    '';
  };
}
