{ stdenv }:
stdenv.mkDerivation rec {
  name = "fs-diff";

  src = ./fs-diff.sh;

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    install $src $out/bin/fs-diff
  '';

  # checkPhase = ''
  #   ${stdenv.shell} -n -O extglob $out/bin/${name}
  # '';

  meta.description = "Returns diff between subvol blank and current";
}
