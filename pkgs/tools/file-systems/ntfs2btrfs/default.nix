{ stdenv
, lib
, cmake
, fmt
, sources
}:
stdenv.mkDerivation {
  inherit (sources.ntfs2btrfs) pname src version;

  buildInputs = [ cmake fmt ];

  meta = with lib; {
    homepage = "https://github.com/maharmstone/ntfs2btrfs";
    license = licenses.gpl2;
    platform = platforms.linux;
  };
}
