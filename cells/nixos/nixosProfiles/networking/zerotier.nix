# unmaintained
{...}: {
  services.zerotierone = {
    enable = true;
    joinNetworks = [
      # deleted
      "52b337794fcd1f9f"
      # deleted
      "632ea2908585cca3"
    ];
  };

  networking.firewall.trustedInterfaces = [
    # deleted
    "ztfp6puzwq" # 52b337794fcd1f9f
    # deleted
    "zt6ovsoxbg" # 632ea2908585cca3
  ];
}
