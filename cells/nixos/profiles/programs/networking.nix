{pkgs, ...}: {
  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      dnsutils
      doggo
      iptables
      iputils
      nmap
      wireguard-tools
      ;
  };

  environment.shellAliases = {
    dns = "doggo";
  };
}
