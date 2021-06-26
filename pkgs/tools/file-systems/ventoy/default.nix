{ stdenv, lib, sources, autoPatchelfHook, makeWrapper }:
stdenv.mkDerivation rec {
  inherit (sources) pname src version;

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

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
    maintainers = [ danielphan2003 ];
    platforms = [ "x86_64-linux" ];
  };
}
