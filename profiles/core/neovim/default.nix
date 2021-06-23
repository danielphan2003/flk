{ pkgs, ... }:
let inherit (builtins) attrValues;
in
{
  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  environment.systemPackages = attrValues {
    inherit (pkgs) neovim;
  };
}
