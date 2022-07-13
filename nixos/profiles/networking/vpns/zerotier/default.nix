{...}: {
  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "52b337794fcd1f9f"
      "632ea2908585cca3"
    ];
  };

  networking.firewall.trustedInterfaces = [
    "ztfp6puzwq" # 52b337794fcd1f9f
    "zt6ovsoxbg" # 632ea2908585cca3
  ];
}
