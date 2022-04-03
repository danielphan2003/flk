{
  rustPlatform,
  lib,
  sources,
  cmake,
  pkg-config,
  alsa-lib,
  gtk3,
  libvpx,
  libxcb,
  libxfixes,
  libyuv,
  nasm,
  opus,
  pulseaudio,
  sciter,
  xdotool,
  yasm,
}:
rustPlatform.buildRustPackage {
  inherit (sources.rustdesk) pname version src cargoLock;

  nativeBuildInputs = [cmake pkg-config];

  buildInputs = [
    alsa-lib
    gtk3
    libvpx
    libxcb
    libxfixes
    libyuv
    nasm
    opus
    pulseaudio
    sciter
    xdotool
    yasm
  ];

  postInstall = ''
    ln -s $src/src $out/share/$pname
    install -Dm0644 $src/logo-header.svg $out/share/pixmaps/$pname.png
  '';

  meta = with lib; {
    description = "Yet another remote desktop software";
    homepage = "https://rustdesk.com";
    license = licenses.gpl3;
    maintainers = [danielphan2003];
  };
}
