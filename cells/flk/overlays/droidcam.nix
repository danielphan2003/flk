final: prev: {
  droidcam = prev.droidcam.overrideAttrs (o: {
    postInstall = ''
      mkdir -p $out/share/applications
      substitute $src/droidcam.desktop $out/share/applications/droidcam.desktop \
        --replace "/opt/droidcam-icon.png" "$out/share/icons/hicolor/96x96/apps/droidcam.png" \
        --replace "/usr/local" "$out"
    '';
  });
}
