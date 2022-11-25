final: prev: {
  betterdiscord-installer = let
    inherit (final.fog.betterdiscord-installer) pname src version;
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

  # discord-canary = prev.discord-canary.overrideAttrs (o: {
  #   inherit (final.fog.discord-canary) pname src version;

  #   # every discord wayland is currently broken in wlroots
  #   installPhase = ''
  #     ${o.installPhase}
  #     sed -i 's/exec/unset NIXOS_OZONE_WL\nexec/g' $out/opt/DiscordCanary/DiscordCanary
  #   '';

  #   postInstall = ''
  #     cp -f ${final.openasar} $out/opt/${o.meta.mainProgram}/resources/app.asar
  #   '';
  # });
}
