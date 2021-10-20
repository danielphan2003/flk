{ stdenv
, lib
, username ? "nixos"
, fetchurl ? null
, icon ? fetchurl {
    url = "https://nixos.org/favicon.png";
    sha256 = "${lib.fakeSha256}";
  }
}:
stdenv.mkDerivation {
  name = "${username}-icon";

  src = icon;

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/sddm/faces
    cp $src $out/share/sddm/faces/${username}.face.icon
  '';

  meta = with lib; {
    description = "User icon for SDDM etc.";
    platforms = platforms.all;
    license =
      if isDerivation icon
      then
        if head icon.urls == "https://nixos.org/favicon.png"
        then licenses.cc-by-sa-40
        else null
      else null;
  };
}
