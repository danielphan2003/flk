{
  config,
  inputs,
  lib,
  profiles,
  ...
}: {
  imports = [
    inputs.bootspec-secureboot.nixosModules.bootspec-secureboot
    profiles.boot.systemd-boot
  ];

  options.boot.loader.external = {
    enable = lib.mkEnableOption "manual configuration of the bootloader";

    installHook = lib.mkOption {
      type = with lib.types; nullOr package;
      default = null;
      description = ''
        A shell script that will be run as part of the bootloader installation process.
        Use <code>writeShellScript</code>, and <code>$1</code> may be used to refer to the output of the system's toplevel.
      '';
    };
  };

  config = {
    boot.loader.manual = config.boot.loader.external;

    boot.loader.systemd-boot.enable = false;
    boot.loader.grub.enable = false;

    boot.loader.secureboot = {
      enable = true;
      # doesn't work with relative path
      signingKeyPath = "${./.}/db.key";
      signingCertPath = "${./.}/db.crt";
    };
  };
}
