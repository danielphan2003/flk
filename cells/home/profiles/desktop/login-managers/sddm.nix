# unmaintained
{
  self,
  config,
  pkgs,
  ...
}: {
  home.packages = [
    (pkgs.user-icon.override rec {
      inherit (config.home) username;
      icon = "${self}/home/users/${username}/icon.png";
    })
  ];
}
