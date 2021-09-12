{ ... }: {
  services.adguardhome = {
    enable = true;
    port = 3000;
    openFirewall = true;
  };
}
