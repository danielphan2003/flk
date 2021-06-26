{ appimageTools, lib, sources, gsettings-desktop-schemas, gtk3 }:
let inherit (sources.leonflix) pname src version; in
appimageTools.wrapType2 rec {
  inherit src;

  name = "${pname}-${version}";

  profile = ''
    export LC_ALL=C.UTF-8
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  multiPkgs = null; # no 32bit needed
  extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;
  extraInstallCommands = '' 
    mv $out/bin/{${name},${pname}}
    # Desktop file
    mkdir -p $out/share/applications
    cp ${./leonflix.desktop} $out/share/applications
  '';

  meta = with lib; {
    description = "free media thing";
    homepage = https://www.leonflix.net;
    license = licenses.asl20;
    # Should be cross-platform, but for now we just grab the appimage
    platforms = [ "x86_64-linux" ];
    maintainers = [ danielphan2003 ];
  };
}
