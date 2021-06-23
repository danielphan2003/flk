{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, makeWrapper
}:
let version = "1.0.36";
in
stdenv.mkDerivation rec {
  name = "ventoy";

  src = fetchurl {
    url = "https://github.com/ventoy/Ventoy/releases/download/v${version}/ventoy-${version}-linux.tar.gz";
    sha256 = "sha256-TT2ot+FGThHnMlxWk/6S1tCGAH95TF3owQHiZh1JTFg=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  installPhase = ''
    mkdir -p $out/bin $out/opt/ventoy
    awk 'NR==4{print "cd $out"}1' ./Ventoy2Disk.sh
    awk 'NR==2{print "cd $out"}1' ./VentoyWeb.sh
    cp -r * $out/opt/ventoy
    makeWrapper $out/opt/ventoy/Ventoy2Disk.sh $out/bin/ventoy
    makeWrapper $out/opt/ventoy/VentoyWeb.sh $out/bin/VentoyWeb
  '';

  meta = with lib; {
    description = "An open source tool to create bootable USB drive for ISO files";
    homepage = "https://ventoy.net";
    license = licenses.gpl3;
    maintainers = with maintainers; [ filalex77 ];
    # Should be cross-platform, but for now we just grab the appimage
    platforms = [ "x86_64-linux" ];
  };
}
