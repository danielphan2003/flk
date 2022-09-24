{
  lib,
  fog,
  rustPlatform,
  pkg-config,
  udev,
  e2fsprogs,
}:
rustPlatform.buildRustPackage {
  inherit (fog.asusctl) pname src version;

  cargoLock = fog.asusctl.cargoLock."Cargo.lock";

  nativeBuildInputs = [pkg-config];

  buildInputs = [udev];

  prePatch = ''
    for file in \
      daemon-user/src/user_config.rs \
      daemon/src/ctrl_anime/config.rs
    do
      substituteInPlace $file \
        --replace /usr/share/ $out/share/
    done

    substituteInPlace daemon/src/ctrl_rog_bios.rs \
      --replace /usr/bin/chattr ${e2fsprogs}/bin/chattr
  '';

  preInstall = ''
    # Install the data.
    # Let buildRustPackage handle installing build output in installPhase.
    make install \
      DESTDIR="$out" \
      INSTALL_PROGRAM=true \
      INSTALL_DATA="install -D -m 0444" \
      prefix=""
  '';

  meta = with lib; {
    description = "A control daemon, CLI tools, and a collection of crates for interacting with ASUS ROG laptops.";
    homepage = "https://gitlab.com/asus-linux/asusctl";
    license = with licenses; [mpl20];
    platforms = platforms.linux;
    maintainers = with maintainers; [bobvanderlinden kravemir];
  };
}
