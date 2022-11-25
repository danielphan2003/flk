{...}: {
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix#L75
  boot.loader.systemd-boot.editor = false;

  # programs.firejail.enable = true;

  security.protectKernelImage = true;

  # security.auditd.enable = true;
  # security.audit.enable = !config.boot.isContainer;
}
