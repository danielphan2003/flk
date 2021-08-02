{ lib
, sources
, makeRustPlatform
, rust-bin
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

let
  cargo = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default.override {
    extensions = [
      "cargo"
      "rust-std"
      "rustc"
      "rustfmt"
    ];
  });
  rustc = cargo;
  rustPlatform = makeRustPlatform { inherit cargo rustc; };
in

rustPlatform.buildRustPackage rec {
  inherit (sources.eww) pname version src cargoLock;

  cargoBuildFlags = with lib; [
    "--no-default-features"
    (optionalString enableWayland "--features=wayland")
  ];

  verifyCargoDeps = true;

  nativeBuildInputs = [ wrapGAppsHook pkg-config ];

  buildInputs = [
    gtk3
    cairo
    glib
    atk
    pango
    gdk-pixbuf
    gtk-layer-shell
  ]
  ++ (lib.optionals enableWayland [ wayland wayland-protocols ]);

  preBuild = ''
    echo $NIX_LDFLAGS
  '';

  meta = with lib; {
    description = "A standalone widget system made in Rust to add AwesomeWM like widgets to any WM";
    homepage = "https://github.com/elkowar/eww";
    license = licenses.mit;
    broken = true;
    maintainers = with maintainers; [ fortuneteller2k danielphan2003 ];
  };
}
