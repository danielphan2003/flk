final: prev: {
  spicetify-cli = prev.spicetify-cli.overrideAttrs (_: {
    inherit (final.dan-nixpkgs.spicetify-cli) pname version src;
    postInstall = ''
      cp -r ./jsHelper ./Themes ./Extensions ./CustomApps ./globals.d.ts ./css-map.json $out/bin
    '';
  });

  spotify-unwrapped = prev.spotify-unwrapped.overrideAttrs (_: {
    inherit (final.dan-nixpkgs.spotify) src version;
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

  spotify-unwrapped-1_1_83_954_gd226dfe8 = final.spotify-unwrapped.overrideAttrs (_: {
    inherit (final.dan-nixpkgs.spotify-1_1_83_954_gd226dfe8) src version;
  });

  spotifyd = prev.spotifyd.override {
    rustPackages.rustPlatform.buildRustPackage = args:
      final.rustPackages.rustPlatform.buildRustPackage
        (builtins.removeAttrs args ["cargoSha256"] // {
          inherit (final.dan-nixpkgs.spotifyd) src version;
          cargoLock = final.dan-nixpkgs.spotifyd.cargoLock."Cargo.lock";
        });
  };
}
