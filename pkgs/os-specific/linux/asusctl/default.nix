{
  stdenv,
  lib,
  sources,
  rustPlatform,
  rust,
  pkg-config,
  libudev,
}:
rustPlatform.buildRustPackage {
  inherit (sources.asusctl) pname src version cargoLock;

  nativeBuildInputs = [pkg-config];
  buildInputs = [libudev];

  doCheck = false;

  postPatch = ''
    # The build is placed under target/x86_64-unknown-linux-gnu/release, while Makefile expects it under
    # target/release. We'll create target/release to be compatible with Makefile.
    substituteInPlace Makefile \
      --replace "./target/release/" "./target/${rust.toRustTargetSpec stdenv.hostPlatform}/release/"
  '';

  # Avoid referring to systemd from udev rules file to avoid dependency on systemd.
  # substituteInPlace data/asusd.rules \
  #   --replace "systemctl" "${systemd}/bin/systemctl"

  installPhase = ''
    make install DESTDIR="$out" prefix=""
  '';

  meta = with lib; {
    description = "A control daemon, CLI tools, and a collection of crates for interacting with ASUS ROG laptops.";
    homepage = "https://gitlab.com/asus-linux/asusctl";
    license = with licenses; [mpl20];
    platforms = platforms.linux;
    maintainers = with maintainers; [danielphan2003];
  };
}
