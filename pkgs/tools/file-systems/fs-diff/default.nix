{ stdenv }:
let name = "fs-diff"; in
stdenv.mkDerivation {
  inherit name;

  src = ./fs-diff.sh;

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    install $src $out/bin/${name}
  '';

  # checkPhase = ''
  #   ${stdenv.shell} -n -O extglob $out/bin/${name}
  # '';

  meta.description = "Returns diff between subvol blank and current";
}
