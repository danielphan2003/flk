{
  config,
  lib,
  profiles,
  ...
}: {
  imports = [profiles.boot.systemd-boot.stage2];

  boot.initrd.systemd.enable = lib.mkDefault config.boot.loader.systemd-boot.enable;
}
