{ lib, config, ... }: {
  services.resolved = {
    enable = lib.mkDefault true;
    dnssec = lib.mkDefault "true";
    fallbackDns = [
      "9.9.9.9"
      "149.112.112.112"
    ];
  };
}
