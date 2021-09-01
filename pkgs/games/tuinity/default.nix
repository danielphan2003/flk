{ lib, stdenv, sources, bash, jre }:
let
  mcVersion = "1.17.1";
  buildId = lib.substring 0 7 sources.tuinitymc.version;
in
stdenv.mkDerivation {
  inherit (sources.tuinitymc) pname src;

  version = "${mcVersion}r${buildId}";

  preferLocalBuild = true;

  dontUnpack = true;
  dontConfigure = true;

  buildPhase = ''
    cat > minecraft-server << EOF
    #!${bash}/bin/sh
    exec ${jre}/bin/java \$@ -jar $out/share/tuinitymc/tuinitymc.jar nogui
  '';

  installPhase = ''
    install -Dm444 $src $out/share/tuinitymc/tuinitymc.jar
    install -Dm555 -t $out/bin minecraft-server
  '';

  meta = {
    description = "Minecraft server software fork of Paper to improve performance without behavioural changes. ";
    homepage = "https://github.com/tuinity/tuinity";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ danielphan2003 ];
  };
}
