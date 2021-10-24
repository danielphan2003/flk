{ config, pkgs, ... }: {
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix#L66
  boot.loader.systemd-boot.editor = false;

  programs.firejail.enable = true;

  # Swap ‹sudo› for ‹doas›
  security.doas.enable = true;
  security.sudo.enable = false;

  security.protectKernelImage = true;

  environment.shellAliases = {
    sudo = "doas";
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) physlock;
  };

  security.doas.extraRules = [
    {
      groups = [ "wheel" ];
      keepEnv = true;
    }
    {
      groups = [ "wheel" ];
      cmd = "${pkgs.physlock}/bin/physlock";
      noPass = true;
      keepEnv = true;
    }
  ];
}
