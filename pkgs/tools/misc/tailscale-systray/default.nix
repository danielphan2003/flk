{
  lib,
  buildGoApplication,
  dan-nixpkgs,
  pkg-config,
  wrapGAppsHook,
  gobject-introspection,
  libappindicator,
  gtk-layer-shell,
  gtk3,
  pango,
  gdk-pixbuf,
  atk,
}:
buildGoApplication {
  inherit (dan-nixpkgs.tailscale-systray) pname src version;

  CGO_ENABLED = "1";

  modules = ./gomod2nix.toml;

  subPackages = ["."];

  buildInputs = [atk gtk3 gdk-pixbuf gtk-layer-shell pango libappindicator];
  nativeBuildInputs = [pkg-config wrapGAppsHook gobject-introspection];

  postInstall = ''
    mkdir -p $out/share
    cp -r --parent icon $out/share
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "$out/share")
  '';

  meta = with lib; {
    description = "Linux port of tailscale system tray menu";
    homepage = "https://github.com/mattn/tailscale-systray";
    platforms = platforms.unix;
    maintainers = [maintainers.danielphan2003];
  };
}
