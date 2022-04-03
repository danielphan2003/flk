{pkgs, ...}: {
  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) neovim;
  };
}
