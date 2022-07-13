{pkgs, ...}: {
  # Install the polkit rules.
  environment.systemPackages = [pkgs.swhkd];

  # Install the systemd unit.
  systemd.packages = [pkgs.swhkd];
}
