{ pkgs, lib, config, anboxModulesPath, ... }:
{
  imports = [ "${anboxModulesPath}/virtualisation/anbox.nix" ];
  disabledModules = [ "virtualisation/anbox.nix" ];

  environment.systemPackages = with pkgs; [
    android-desktop
  ];

  # virtualisation.anbox = {
  #   enable = (config.boot.kernelPackages == pkgs.linuxPackages_5_4);

  #   image = pkgs.anbox-postmarketos-image;

  #   ipv4.dns = "9.9.9.9";

  #   # https://gitlab.com/postmarketOS/pmaports/-/blob/bf6ad7a78c5506eb5ad9089e87f9c1cf7e8cd1f8/main/anbox-image/APKBUILD#L39-63
  #   imageModifications =
  #     let
  #       fdroid_apk = pkgs.fetchurl {
  #         url = "https://f-droid.org/repo/org.fdroid.fdroid_1013000.apk";
  #         sha256 = "1n5zcxsfn42b3i067pnkjy3xf5ljs0fj9h01v69xfincr84mlh0y";
  #       };
  #       fdroidpriv_apk = pkgs.fetchurl {
  #         url = "https://f-droid.org/repo/org.fdroid.fdroid.privileged_2120.apk";
  #         sha256 = "1axa72vfd8qq2dyk7d171vpwb6rf5ps59zrchhhgqmrqmpv88gww";
  #       };
  #     in
  #     ''
  #       (PS4=" $ "; set -x

  #         echo "Disabling su"
  #         rm -v system/xbin/su

  #         echo "Installing FDroid"
  #         mkdir system/app/FDroid
  #         mkdir system/priv-app/FDroid

  #         cp "${fdroid_apk}"     system/app/FDroid/${fdroid_apk.name}
  #         cp "${fdroidpriv_apk}" system/priv-app/FDroid/${fdroidpriv_apk.name}

  #         chmod 0644 system/app/FDroid/*
  #         chmod 0644 system/priv-app/FDroid/*
  #       )
  #     '';
  # };

  # boot.kernelModules = [ "ashmem_linux" "binder_linux" ];

  # boot.extraModulePackages = [ pkgs.linuxPackages_5_12.anbox ];

  # system.requiredKernelConfig = [
  #   "ASHMEM"
  #   "ANDROID"
  #   "ANDROID_BINDER_IPC"
  #   "ANDROID_BINDERFS"
  # ];

  # nixpkgs.config = {
  #   allowBroken = true;
  # };

}
