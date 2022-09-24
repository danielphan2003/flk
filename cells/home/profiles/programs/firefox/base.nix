{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  mozillaConfigPath =
    if isDarwin
    then "Library/Application Support/Mozilla"
    else ".mozilla";
in {
  programs.firefox = {
    enable = true;

    # To prevent fingerprinting, arkenfox users might want to use stable firefox instead
    package = lib.mkDefault (pkgs.firefox-nightly-bin.override (import ./overrides.nix));

    profiles.default = {
      name = config.home.username;
      id = 0;
      isDefault = true;
    };
  };
}
