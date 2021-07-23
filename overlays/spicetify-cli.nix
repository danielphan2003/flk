final: prev: {
  spicetify-cli = prev.spicetify-cli.overrideAttrs (o:
    let branch = prev.lib.optionalString (o ? legacySupport) "-v1"; in
    rec {
      inherit (final.sources."spicetify-cli${branch}") pname version src;
      postInstall = ''
        cp -r ${src}/jsHelper ${src}/Themes ${src}/Extensions ${src}/CustomApps ${src}/globals.d.ts ${src}/css-map.json $out/bin
      '';
    });

  spotify-unwrapped = prev.spotify-unwrapped.overrideAttrs (o:
    prev.lib.optionalAttrs
      (! o ? legacySupport)
      {
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
}
