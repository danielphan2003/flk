final: prev: {
  betterdiscord-installer = let
    inherit (final.dan-nixpkgs.betterdiscord-installer) pname src version;
    name = "${pname}-${version}";

    appimageContents = final.appimageTools.extract {inherit name src;};
  in
    final.appimageTools.wrapType2 {
      inherit (prev.betterdiscord-installer) meta;
      inherit name src;

      extraInstallCommands = ''
        mv $out/bin/${name} $out/bin/${pname}

        install -m 444 -D ${appimageContents}/betterdiscord-installer.desktop -t $out/share/applications
        substituteInPlace $out/share/applications/betterdiscord-installer.desktop \
          --replace 'Exec=AppRun' 'Exec=${pname}'
        cp -r ${appimageContents}/usr/share/icons $out/share
      '';
    };

  betterdiscordctl = prev.betterdiscordctl.overrideAttrs (_: {
    inherit (final.sources.betterdiscordctl) src version;
  });
}
