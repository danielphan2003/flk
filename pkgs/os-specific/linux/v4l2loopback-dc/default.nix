{ stdenv
, srcs
, lib
, kernel
, kmod
}:
let inherit (srcs) droidcam; in
stdenv.mkDerivation rec {
  inherit (droidcam) version;

  name = "v4l2loopback-dc-${version}-${kernel.version}";

  src = droidcam;

  sourceRoot = "source/linux/v4l2loopback";
  hardeningDisable = [ "pic" "format" ]; # 1
  nativeBuildInputs = kernel.moduleBuildDependencies; # 2

  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}" # 3
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" # 4
    "INSTALL_MOD_PATH=$(out)" # 5
  ];

  meta = with lib; {
    description = "A kernel module to create V4L2 loopback devices";
    homepage = "https://github.com/aramg/droidcam";
    license = licenses.gpl2;
    maintainers = [ maintainers.makefu ];
    platforms = platforms.linux;
  };
}
