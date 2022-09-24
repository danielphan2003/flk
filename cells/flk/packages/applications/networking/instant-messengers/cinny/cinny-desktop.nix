{
  lib,
  fog,
  rustPlatform,
  cinny-web,
  substituteAll,
  pkg-config,
  dbus,
  openssl,
  sass,
  glib,
  cairo,
  pango,
  atk,
  gdk-pixbuf,
  libsoup,
  gtk3,
  webkitgtk,
  librsvg,
  patchelf,
  vips,
  sqlite,
  gst_all_1,
  libappindicator-gtk3,
  glib-networking,
  makeWrapper,
  makeDesktopItem,
  conf ? {},
}: let
  inherit (fog.cinny-desktop) pname src version cargoLock;

  cinny-web' = cinny-web.override {inherit conf;};

  set = k: v: "--set ${k} ${v}";

  prefix = k: v: "--prefix ${k} : ${v}";

  makeWrapperArgs = builtins.concatStringsSep " " [
    (set "GDK_PIXBUF_MODULE_FILE" "${librsvg}/${gdk-pixbuf.moduleDir}.cache")
    (prefix "XDG_DATA_DIRS" "$out/share")
    (prefix "GIO_EXTRA_MODULES" "${lib.getLib glib-networking}/lib/gio/modules")
    (prefix "XDG_DATA_DIRS" "${gtk3}/share")
    (prefix "GI_TYPELIB_PATH"
      (lib.makeSearchPath "lib/girepository-1.0" [gtk3 atk gdk-pixbuf librsvg]))
  ];

  desktopItem = makeDesktopItem {
    name = "cinny";
    desktopName = "Cinny";
    comment = "Yet another matrix client with simple, elegant and secure interface.";
    icon = "${src}/src-tauri/icons/icon.png";
    exec = "@out@/bin/cinny";
    terminal = false;
    categories = ["Network" "InstantMessaging"];
    keywords = ["Matrix" "matrix.org" "chat" "irc" "communications" "talk" "riot" "element" "fractal" "voip"];
    extraConfig = {
      X-Purism-FormFactor = "Workstation;Mobile;";
    };
  };
in
  rustPlatform.buildRustPackage {
    inherit pname version;

    src = "${src}/src-tauri";

    patches = [
      (substituteAll {
        src = ./cinny-web-distDir.patch;
        distDir = cinny-web';
      })
    ];

    cargoLock = cargoLock."src-tauri/Cargo.lock";

    buildInputs = [
      dbus
      openssl
      sass
      glib
      cairo
      pango
      atk
      gdk-pixbuf
      libsoup
      gtk3
      webkitgtk
      librsvg
      patchelf
      vips
      sqlite
      gst_all_1.gst-plugins-good
      libappindicator-gtk3
      glib-networking
    ];

    nativeBuildInputs = [pkg-config makeWrapper];

    postInstall = ''
      wrapProgram $out/bin/cinny ${makeWrapperArgs}
    '';

    postPatch = ''
      mkdir -p $out/share/applications
      substitute ${desktopItem}/share/applications/cinny.desktop $out/share/applications/in.cinny.Cinny.desktop \
        --subst-var out
    '';

    meta = with lib; {
      description = "Yet another matrix client for desktop";
      homepage = "https://github.com/cinnyapp/cinny-desktop";
      maintainers = [maintainers.danielphan2003];
      platforms = platforms.linux;
    };
  }
