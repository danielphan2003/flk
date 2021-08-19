{ pkgs, ... }:
let inherit (builtins) attrValues;
in
{
  environment.systemPackages = attrValues ({
    inherit (pkgs)
      element-desktop
      tdesktop
      ;
  }
  //
  (if pkgs.system == "x86_64-linux"
  then
    {
      inherit (pkgs) discord-canary signal-desktop;
    }
  else
    {
      inherit (pkgs) cordless signal-cli;
    }));
}
