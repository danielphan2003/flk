{ stdenv
, lib
, sources
, patchelf
, makeWrapper

  # Linked dynamic libraries.
, glib
, glibc
, fontconfig
, freetype
, pango
, cairo
, libX11
, libXi
, atk
, gconf
, nss
, nspr
, libXcursor
, libXext
, libXfixes
, libXrender
, libXScrnSaver
, libXcomposite
, libxcb
, alsa-lib
, libXdamage
, libXtst
, libXrandr
, libxshmfence
, expat
, cups
, file
, dbus
, gtk3
, gdk-pixbuf
, gcc-unwrapped
, at-spi2-atk
, at-spi2-core
, libuuid
, libkrb5
, libdrm
, mesa
, widevine-cdm
, libxkbcommon
, wayland # ozone/wayland

  # Command line programs
, coreutils

  # command line arguments which are always set e.g "--disable-gpu"
, commandLineArgs ? ""

  # Will crash without.
, systemd

  # Loaded at runtime.
, libexif
, pciutils

  # Additional dependencies according to other distros.
  ## Ubuntu
, liberation_ttf
, curl
, util-linux
, xdg-utils
, wget
  ## Arch Linux.
, flac
, harfbuzz
, icu
, libpng
, libopus
, snappy
, speechd
  ## Gentoo
, bzip2
, libcap

  # Which distribution channel to use.
, channel ? "beta"

  # Necessary for USB audio devices.
, pulseSupport ? true
, libpulseaudio ? null

, gsettings-desktop-schemas
, gnome

  # For video acceleration via VA-API (--enable-features=VaapiVideoDecoder)
, libvaSupport ? true
, libva

  # For Vulkan support (--enable-features=Vulkan)
, vulkanSupport ? true
, vulkan-loader
}:

with lib;

let
  opusWithCustomModes = libopus.override {
    withCustomModes = true;
  };

  deps = [
    glibc
    glib
    fontconfig
    freetype
    pango
    cairo
    libX11
    libXi
    atk
    gconf
    nss
    nspr
    libXcursor
    libXext
    libXfixes
    libXrender
    libXScrnSaver
    libXcomposite
    libxcb
    alsa-lib
    libXdamage
    libXtst
    libXrandr
    libxshmfence
    expat
    cups
    file
    dbus
    gdk-pixbuf
    gcc-unwrapped.lib
    systemd
    libexif
    pciutils
    liberation_ttf
    curl
    util-linux
    xdg-utils
    wget
    flac
    harfbuzz
    icu
    libpng
    opusWithCustomModes
    snappy
    speechd
    bzip2
    libcap
    at-spi2-atk
    at-spi2-core
    libuuid
    libkrb5
    libdrm
    mesa
    coreutils
    libxkbcommon
    wayland
  ] ++ optional pulseSupport libpulseaudio
  ++ optional libvaSupport libva
  ++ optional vulkanSupport vulkan-loader
  ++ [ gtk3 ];
in

stdenv.mkDerivation rec {
  pname = "microsoft-edge-${channel}";

  inherit (sources."${pname}") src version;

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    ar x $src
    tar xf data.tar.xz
  '';

  nativeBuildInputs = [ patchelf makeWrapper ];
  buildInputs = [
    # needed for GSETTINGS_SCHEMAS_PATH
    gsettings-desktop-schemas
    glib
    gtk3

    # needed for XDG_ICON_DIRS
    gnome.adwaita-icon-theme
  ];

  rpath = makeLibraryPath deps + ":" + makeSearchPathOutput "lib" "lib64" deps;
  binpath = makeBinPath deps;

  installPhase = ''
    case ${channel} in
      beta) appname=msedge-beta  dist=beta     ;;
      dev)  appname=msedge-dev   dist=dev      ;;
      *)    appname=msedge       dist=stable   ;;
    esac

    exe=$out/bin/$pname

    mkdir -p $out/bin $out/share

    cp -a opt/* $out/share
    cp -a usr/share/* $out/share

    # ln -sf $out/share/microsoft/$appname/$pname $out/share/microsoft/$appname/microsoft-edge
    ln -sf $out/share/microsoft/$appname/$pname $exe

    rm -rf $out/share/doc
    rm -rf $out/share/microsoft/$appname/cron

    # To fix --use-gl=egl:
    test -e $out/share/microsoft/$appname/libEGL.so
    ln -s libEGL.so $out/share/microsoft/$appname/libEGL.so.1
    test -e $out/share/microsoft/$appname/libGLESv2.so
    ln -s libGLESv2.so $out/share/microsoft/$appname/libGLESv2.so.2

    rm $out/share/microsoft/$appname/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so
    ln -s ${widevine-cdm}/lib/libwidevinecdm.so $out/share/microsoft/$appname/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so

    substituteInPlace $out/share/applications/$pname.desktop \
      --replace "/usr/bin/$pname" "$exe"

    substituteInPlace $out/share/gnome-control-center/default-apps/$pname.xml \
      --replace /opt/share/microsoft/$appname $out/share/microsoft/$appname

    substituteInPlace $out/share/menu/$pname.menu \
      --replace /opt/share/microsoft/$appname $out/share/microsoft/$appname

    substituteInPlace $out/share/microsoft/$appname/xdg-mime \
      --replace "''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}" "''${XDG_DATA_DIRS:-/run/current-system/sw/share}" \
      --replace "xdg_system_dirs=/usr/local/share/:/usr/share/" "xdg_system_dirs=/run/current-system/sw/share/" \
      --replace /usr/bin/file ${file}/bin/file

    substituteInPlace $out/share/microsoft/$appname/default-app-block \
      --replace /opt/share/microsoft/$appname $out/share/microsoft/$appname

    substituteInPlace $out/share/microsoft/$appname/xdg-settings \
      --replace "''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}" "''${XDG_DATA_DIRS:-/run/current-system/sw/share}" \
      --replace "''${XDG_CONFIG_DIRS:-/etc/xdg}" "''${XDG_CONFIG_DIRS:-/run/current-system/sw/etc/xdg}"

    for icon_file in $out/share/microsoft/$appname/product_logo_[0-9]*.png; do
      num_and_suffix="''${icon_file##*logo_}"
      if [ $dist = "stable" ]; then
        icon_size="''${num_and_suffix%.*}"
      else
        icon_size="''${num_and_suffix%_*}"
      fi
      logo_output_prefix="$out/share/icons/hicolor"
      logo_output_path="$logo_output_prefix/''${icon_size}x''${icon_size}/apps"
      mkdir -p "$logo_output_path"
      mv "$icon_file" "$logo_output_path/$appname.png"
    done
  '';

  fixupPhase = ''
    rpath="$rpath:$out/share/microsoft/$appname"

    makeWrapper "$out/share/microsoft/$appname/msedge" "$exe" \
      --prefix LD_LIBRARY_PATH : "$rpath" \
      --prefix PATH            : "$binpath" \
      --prefix XDG_DATA_DIRS   : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH" \
      --add-flags ${escapeShellArg commandLineArgs}

    for elf in $out/share/microsoft/$appname/{libsmartscreen.so,libGLESv2.so}; do
      patchelf \
        --set-rpath $rpath \
        $elf
    done

    for elf in $out/share/microsoft/$appname/{msedge,msedge-sandbox,crashpad_handler,nacl_helper}; do
      patchelf \
        --set-rpath $rpath \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $elf
    done
  '';

  meta = {
    homepage = "https://www.microsoftedgeinsider.com/";
    changelog = "https://www.microsoftedgeinsider.com/en-us/whats-new";
    description = "Microsoft's fork of Chromium web browser";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.danielphan2003 ];
  };
}
