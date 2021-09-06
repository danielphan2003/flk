{ stdenv
, lib
, cmake
, fmt
, zlib
, sources
}:
stdenv.mkDerivation {
  inherit (sources.ntfs2btrfs) pname src version;

  buildInputs = [ cmake fmt zlib ];

  meta = with lib; {
    homepage = "https://github.com/maharmstone/ntfs2btrfs";
    license = licenses.gpl2;
    platform = platforms.linux;
  };
}
