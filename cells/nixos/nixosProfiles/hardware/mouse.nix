{pkgs, ...}: {
  services.ratbag.enable = true;
  environment.systemPackages = [pkgs.piper];
}
