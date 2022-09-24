{pkgs, ...}: {
  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      binutils
      btop
      coreutils
      curl
      direnv
      jq
      moreutils
      pciutils
      procps
      psmisc
      rsync
      tealdeer
      usbutils
      utillinux
      wget
      whois
      ;
  };

  environment.shellAliases = {
    top = "btop";
  };
}
