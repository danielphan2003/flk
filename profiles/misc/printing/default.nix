{ pkgs, ... }:
let inherit (builtins) attrValues;
in
{
  services.printing = {
    enable = true;
    cups-pdf = {
      enable = true;
    };
    drivers = attrValues {
      inherit (pkgs)
        hplip brlaser brgenml1lpr brgenml1cupswrapper;
    };
  };
  hardware.sane = {
    enable = true;
    extraBackends = attrValues {
      inherit (pkgs) hplip;
    };
  };
}
