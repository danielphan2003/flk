{pkgs, ...}: {
  # Swap ‹sudo› for ‹doas›
  security.doas.enable = true;
  security.sudo.enable = false;

  environment.shellAliases = {
    sudo = "doas";
  };

  security.doas.extraRules = [
    {
      groups = ["wheel"];
      persist = true;
      keepEnv = true;
    }
    {
      groups = ["wheel"];
      keepEnv = true;
      cmd = "${pkgs.physlock}/bin/physlock";
      noPass = true;
    }
  ];
}
