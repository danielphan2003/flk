{
  lib,
  fog,
  rustPlatform,
  pkg-config,
  udev,
  kmod,
}:
rustPlatform.buildRustPackage {
  inherit (fog.supergfxctl) pname src version;

  cargoLock = fog.supergfxctl.cargoLock."Cargo.lock";

  nativeBuildInputs = [pkg-config];

  buildInputs = [udev];

  # Need to run on an actual laptop
  doCheck = false;

  buildFeatures = ["daemon" "cli"];

  postPatch = ''
    substituteInPlace src/controller.rs \
      --replace '"modprobe"' '"${kmod}/bin/modprobe"' \
      --replace '"rmmod"' '"${kmod}/bin/rmmod"'
  '';

  postInstall = ''
    make install \
      DESTDIR="$out" \
      prefix="" \
      INSTALL_PROGRAM=true \
      INSTALL_DATA="install -Dm 444"
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/asus-linux/supergfxctl";
    license = with licenses; [mpl20];
    platforms = platforms.linux;
    maintainers = with maintainers; [danielphan2003];
  };
}
