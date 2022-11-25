{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  mkOption = enable: str: {
    "${str}" = {
      enable = lib.mkDefault enable;
    };
  };

  enabled = mkOption true;

  disabled = mkOption false;

  mapEnabled = map enabled;

  mapDisabled = map disabled;

  firefoxVersion = "${lib.versions.major config.programs.firefox.package.version}.0";

  defaultArkenfoxVersion =
    if inputs.arkenfox-nixos.lib.arkenfox.extracted ? ${firefoxVersion}
    then firefoxVersion
    else "master";
in {
  programs.firefox = {
    arkenfox.enable = true;

    package = pkgs.firefox.override (import ./overrides.nix);

    arkenfox.version = lib.mkDefault defaultArkenfoxVersion;
  };

  # Misc fingerprinting
  programs.firefox.profiles.default.settings = {
    "image.jxl.enabled" = false;
  };

  programs.firefox.profiles.default.arkenfox = let
    arkenfox = {
      default = {enable = true;};

      enabled = [
        # 0000: TOPLEVEL
        "0000"

        # 0100: STARTUP
        "0100"

        # 0200: GEOLOCATION / LANGUAGE / LOCALE
        "0200"

        # 0300: QUIETER FOX
        "0300"

        # 0600: BLOCK IMPLICIT OUTBOUND [not explicitly asked for - e.g. clicked on]
        "0600"

        # 0700: DNS / DoH / PROXY / SOCKS / IPv6
        "0700"

        # 0800: LOCATION BAR / SEARCH BAR / SUGGESTIONS / HISTORY / FORMS
        "0800"

        # 0900: PASSWORDS
        "0900"

        # 1000: DISK AVOIDANCE
        "1000"

        # 1200: HTTPS (SSL/TLS / OCSP / CERTS / HPKP)
        "1200"

        # 1400: FONTS
        "1400"

        # 1600: HEADERS / REFERERS
        "1600"

        # 1700: CONTAINERS
        "1700"

        # 2000: PLUGINS / MEDIA / WEBRTC
        "2000"

        # 2400: DOM (DOCUMENT OBJECT MODEL)
        "2400"

        # 2600: MISCELLANEOUS
        "2600"

        # 2700: ETP (ENHANCED TRACKING PROTECTION)
        "2700"

        # 2800: SHUTDOWN & SANITIZING
        "2800"

        # 4500: RFP (RESIST FINGERPRINTING)
        # Note that currently amiunique.org still detects the fingerprint as unique
        # This is because of user fonts that it detects via JS
        # and media devices being named as audio{in,out}put
        "4500"

        # 6000: DON'T TOUCH
        "6000"

        # 9000: PERSONAL
        "9000"
      ];

      disabled = [
        # 0400: SAFE BROWSING (SB)
        "0400"

        # 5000: OPTIONAL OPSEC
        "5000"

        # 5500: OPTIONAL HARDENING
        "5500"

        # 7000: DON'T BOTHER
        "7000"

        # 8000: DON'T BOTHER: FINGERPRINTING
        "8000"
      ];
    };
  in
    lib.mkMerge ([arkenfox.default] ++ mapEnabled arkenfox.enabled ++ mapDisabled arkenfox.disabled);
}
