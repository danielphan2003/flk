{
  rustPlatform,
  lib,
  dan-nixpkgs,
  pkg-config,
  clangStdenv,
  clang,
  llvmPackages,
  rocksdb,
}:
rustPlatform.buildRustPackage {
  inherit (dan-nixpkgs.conduit-toolbox) pname src version;

  cargoLock = dan-nixpkgs.conduit-toolbox.cargoLock."Cargo.lock";

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  nativeBuildInputs = [clang llvmPackages.libclang];

  buildInputs = [
    pkg-config
    clangStdenv
    llvmPackages.libclang.lib
    rocksdb
  ];

  meta = with lib; {
    description = "🧰🦀 A bunch of tools that're helpful for conduit";
    homepage = "https://github.com/ShadowJonathan/conduit_toolbox";
    maintainers = with maintainers; [danielphan2003];
  };
}
