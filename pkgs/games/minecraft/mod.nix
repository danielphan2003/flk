{ stdenv, mod, prefix, lib, unzip, fd }:
let
  inherit (mod) src version;
  isZip = path: builtins.baseNameOf path == ".zip";

  pnameStripped = lib.removePrefix prefix mod.pname;
  dontUnpack = !(isZip src.name);
in
stdenv.mkDerivation {
  inherit (mod) pname;
  inherit src version dontUnpack;

  nativeBuildInputs = [ unzip fd ];

  unpackPhase = lib.optionalString (!dontUnpack) ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/share/java

    ${if dontUnpack
      then "ln -s $src ."
      else "fd '.*dev|sources.jar' -X rm"}

    fd '.*-SNAPSHOT.jar' -x mv {} $out/share/java/${pnameStripped}-$version.jar

    fd '.*[.*|\d+\.\d+\.\d+].jar' -x mv {} $out/share/java/${pnameStripped}-$version.jar

    fd '.*fabric.*.jar' -x mv {} $out/share/java/${pnameStripped}-$version.jar
  '';
}
