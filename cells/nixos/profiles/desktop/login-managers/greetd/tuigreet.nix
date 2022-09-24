{
  lib,
  pkgs,
  ...
}: {
  services.greetd = {
    enable = true;
    vt = 1;
    settings.default_session.command = lib.mkDefault "${pkgs.greetd.tuigreet}/bin/tuigreet";
  };
}
