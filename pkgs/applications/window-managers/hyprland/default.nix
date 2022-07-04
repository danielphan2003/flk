{
  lib,
  dan-nixpkgs,
  stdenv,
  cmake,
  pkg-config,
  libdrm,
  libinput,
  libxcb,
  libxkbcommon,
  mesa,
  pango,
  wayland,
  wayland-protocols,
  wlroots,
  xcbutilwm,
}:
stdenv.mkDerivation {
  inherit (dan-nixpkgs.hyprland) pname src version;

  nativeBuildInputs = [
    cmake
    pkg-config

    wayland
  ];

  buildInputs = [
    libdrm
    libinput
    libxcb
    libxkbcommon
    mesa
    pango
    wayland-protocols
    wlroots
    xcbutilwm
  ];

  postPatch = ''
    make config
  '';

  postBuild = ''
    pushd ../hyprctl
    g++ -std=c++20 -w ./main.cpp -o ./hyprctl
    popd
  '';

  installPhase = ''
    mkdir -p $out/bin
    install Hyprland $out/bin
    install -m755 ../hyprctl/hyprctl $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/vaxerski/Hyprland";
    description = "A dynamic tiling Wayland compositor that doesn't sacrifice on its looks";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [wozeparrot];
  };
}
