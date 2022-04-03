channels: final: prev: {
  __dontExport = true; # overrides clutter up actual creations

  droidcam = prev.droidcam.overrideAttrs (o: {
    postInstall = ''
      mkdir -p $out/share/applications
      substitute $src/droidcam.desktop $out/share/applications/droidcam.desktop \
        --replace "/opt/droidcam-icon.png" "$out/share/icons/hicolor/droidcam.png" \
        --replace "/usr/local" "$out"
    '';
  });
}
