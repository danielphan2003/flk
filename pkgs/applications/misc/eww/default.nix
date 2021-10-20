{ lib
, sources
, makeRustPlatform
, wrapGAppsHook
, pkg-config
, gtk3
, cairo
, glib
, atk
, pango
, gdk-pixbuf
, wayland
, wayland-protocols
, gtk-layer-shell
, enableWayland ? false
}:

with lib;

makeRustPlatform.buildRustPackage {
  inherit (sources.eww) pname version src cargoLock;

  cargoBuildFlags = optionals enableWayland [
    "--no-default-features"
    "--features=wayland"
  ];

  nativeBuildInputs = [ wrapGAppsHook pkg-config ];

  buildInputs = [
    gtk3
    cairo
    glib
    atk
    pango
    gdk-pixbuf
    gtk-layer-shell
  ] ++ optionals enableWayland [ wayland wayland-protocols ];

  doCheck = false;

  meta = with lib; {
    description = "A standalone widget system made in Rust to add AwesomeWM like widgets to any WM";
    homepage = "https://github.com/elkowar/eww";
    license = licenses.mit;
    maintainers = with maintainers; [ fortuneteller2k danielphan2003 ];
  };
}
