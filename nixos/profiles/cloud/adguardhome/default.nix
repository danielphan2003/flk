{ ... }: {
  services.adguardhome = {
    enable = true;
    port = 300;
    openFirewall = true;
  };
}
