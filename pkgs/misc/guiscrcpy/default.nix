{
  lib,
  poetry2nix,
  sources,
  python3Packages,
  scrcpy,
  xorg,
}:
with python3Packages;
  poetry2nix.mkPoetryApplication {
    projectDir = sources.guiscrcpy.src;

    buildInputs = [scrcpy xorg.libXinerama];

    overrides = poetry2nix.overrides.withDefaults (p2final: p2prev: {
      pyside2 = lib.traceValFn (v: p2prev.pyside2) p2prev.pyside2.overridePythonAttrs (o: {});
    });

    propagatedBuildInputs = [
      cairosvg
      click
      colorama
      psutil
      pynput
      pyside2
      pyqt5
      qtpy
    ];

    postInstall = ''
      mkdir -p $out/share/{applications,pixmaps}
      install -Dm644 appimage/guiscrcpy.desktop -t "$out/share/applications"
      install -Dm644 appimage/guiscrcpy.png -t "$out/share/pixmaps"
    '';
  }
