{ lib, config, ... }: {
  services.resolved = {
    enable = lib.mkDefault true;
    dnssec = "true";
    fallbackDns = [
      "9.9.9.9"
      "149.112.112.112"
    ];
  };
}
