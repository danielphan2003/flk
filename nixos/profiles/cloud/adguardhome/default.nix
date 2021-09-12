{ ... }: {
  services.adguardhome = {
    enable = true;
    port = 3200;
    openFirewall = true;
  };
}
