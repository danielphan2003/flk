{ stdenv
, fetchurl
}:
stdenv.mkDerivation {
  pname = "sciter";
  version = "4.4.8.3";

  src = fetchurl {
    url = "https://raw.fastgit.org/c-smile/sciter-sdk/master/bin.lnx/x64/libsciter-gtk.so";
    sha256 = "fcf388fc2f1ea41546f5a01104c8764f2467a3c55a3acbbc9b6e4f9807eedc72";
  };

  dontBuild = true;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/sciter
    ln -s $src $out/share/sciter
  '';

}
