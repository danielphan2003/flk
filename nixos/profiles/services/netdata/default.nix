{pkgs, ...}: {
  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      netdata
      ;
  };

  networking.firewall.allowedTCPPorts = [19999];

  services.netdata = {
    enable = true;
    config = {
      global = {
        "debug log" = "syslog";
        "access log" = "syslog";
        "error log" = "syslog";
      };
    };
  };
}
