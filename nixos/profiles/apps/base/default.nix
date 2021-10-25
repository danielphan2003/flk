{ pkgs, ... }: {
  environment.shellAliases.dig = "doggo";

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      binutils
      bottom
      cachix
      coreutils
      curl
      direnv
      dnsutils
      doggo
      fd
      git
      iptables
      iputils
      jq
      moreutils
      pciutils
      rsync
      tealdeer
      usbutils
      utillinux
      wget
      whois
      wireguard-tools
      ;
  };
}
