channels: final: prev: {
  spicetify-cli = prev.spicetify-cli.overrideAttrs (_: {
    inherit (final.sources.spicetify-cli) pname version src;
    postInstall = ''
      cp -r ./jsHelper ./Themes ./Extensions ./CustomApps ./globals.d.ts ./css-map.json $out/bin
    '';
  });

  spotify-unwrapped = prev.spotify-unwrapped.overrideAttrs (o: {
    inherit (final.sources.spotify) src version;
    unpackPhase = ''
      runHook preUnpack
      unsquashfs "$src" '/usr/share/spotify' '/usr/bin/spotify' '/meta/snap.yaml'
      cd squashfs-root
      if ! grep -q 'grade: stable' meta/snap.yaml; then
        # Unfortunately this check is not reliable: At the moment (2018-07-26) the
        # latest version in the "edge" channel is also marked as stable.
        echo "The snap package is marked as unstable:"
        grep 'grade: ' meta/snap.yaml
        echo "You probably chose the wrong revision."
        exit 1
      fi
      runHook postUnpack
    '';
  });

  spotifyd = prev.spotifyd.override {
    rustPackages = prev.rustPackages // {
      rustPlatform = prev.rustPackages.rustPlatform // {
        buildRustPackage = args: prev.rustPackages.rustPlatform.buildRustPackage
          (builtins.removeAttrs args [ "cargoSha256" ] // {
            inherit (final.sources.spotifyd) src version cargoLock;
          });
      };
    };
  };
}
