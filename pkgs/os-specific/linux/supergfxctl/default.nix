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
  inherit (sources.supergfxctl) pname src version;

  nativeBuildInputs = [pkg-config];
  buildInputs = [libudev];

  doCheck = false;

  cargoLock.lockFile = ./Cargo.lock;

  buildFeatures = ["daemon" "cli"];

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
    # The build is placed under target/x86_64-unknown-linux-gnu/release, while Makefile expects it under
    # target/release. We'll create target/release to be compatible with Makefile.
    substituteInPlace Makefile \
      --replace "./target/release/" "./target/${rust.toRustTargetSpec stdenv.hostPlatform}/release/"
  '';

  installPhase = ''
    make install DESTDIR="$out" prefix=""
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/asus-linux/supergfxctl";
    license = with licenses; [mpl20];
    platforms = platforms.linux;
    maintainers = with maintainers; [danielphan2003];
  };
}
