{ pkgs, ... }:
let inherit (builtins) attrValues;
in
{
  environment.systemPackages = attrValues {
    inherit (pkgs)
      discord-canary
      element-desktop
      signal-desktop
      tdesktop
    ;
  };
}
