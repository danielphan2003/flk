{
  stdenv,
  lib,
  pkg-config,
  cmake,
  fmt,
  zlib,
  fog,
  lzo,
  zstd,
}:
stdenv.mkDerivation {
  inherit (fog.ntfs2btrfs) pname src version;

  buildInputs = [pkg-config cmake fmt zlib lzo zstd];

  meta = with lib; {
    homepage = "https://github.com/maharmstone/ntfs2btrfs";
    license = licenses.gpl2;
    platform = platforms.linux;
  };
}
