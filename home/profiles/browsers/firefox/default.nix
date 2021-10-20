{ pkgs, lib, ... }:
let
  inherit (lib) fileContents mkAfter;
  inherit (lib.our) mkFirefoxConfig;

  firefoxConfig = import ./settings.nix;
  mozPath = ".mozilla";
  cfgPath = "${mozPath}/firefox";
in
{
  home.packages = with pkgs; [ firefox-nightly-bin ];

  # programs.firefox = {
  #   enable = true;
  #   package = pkgs.firefox.override {
  #     forceWayland = true;
  #     cfg = {
  #       enableUgetIntegrator = true;
  #       enableFXCastBridge = true;
  #     };
  #     extraPolicies = {
  #       CaptivePortal = false;
  #       DisableFirefoxStudies = true;
  #       DisablePocket = true;
  #       DisableTelemetry = true;
  #       FirefoxHome = {
  #         Pocket = false;
  #         Snippets = false;
  #       };
  #       UserMessaging = {
  #         ExtensionRecommendations = false;
  #         SkipOnboarding = true;
  #       };
  #     };
  #     extraNativeMessagingHosts = [ pkgs.pywalfox ];
  #     extraPrefs = mkFirefoxConfig {
  #       inherit firefoxConfig;
  #       extraConfig = "${fileContents "${pkgs.arkenfox-userjs}/share/user-js/profiles/user.js"}";
  #     };
  #   };
  # };

  home.file = {
    "${cfgPath}/profiles.ini".text = ''
      [Profile0]
      Name=default
      IsRelative=1
      Path=danie.default
      Default=1
      [Profile1]
      Name=test
      IsRelative=1
      Path=random.test
      [General]
      StartWithLastProfile=1
      Version=2
    '';

    "${cfgPath}/danie.default/user.js" = {
      text = mkFirefoxConfig {
        inherit firefoxConfig;
        extraConfig = "${fileContents "${pkgs.arkenfox-userjs}/share/user-js/profiles/user.js"}";
      };
    };

    "${cfgPath}/danie.default/chrome" = {
      source = "${pkgs.flyingfox}/chrome";
      recursive = true;
    };

    # "${cfgPath}/danie.default/chrome/userChrome.css".source =
    #   mkAfter "${pkgs.pywalfox}/share/pywalfox/userChrome.css";

    # "${cfgPath}/danie.default/chrome/userContent.css".source =
    #   mkAfter "${pkgs.pywalfox}/share/pywalfox/userContent.css";

    "${mozPath}/native-messaging-hosts/pywalfox.json".source =
      "${pkgs.pywalfox}/lib/mozilla/native-messaging-hosts/pywalfox.json";

    "${mozPath}/native-messaging-hosts/fx_cast_bridge.json".source =
      "${pkgs.fx_cast_bridge}/lib/mozilla/native-messaging-hosts/fx_cast_bridge.json";
  };
}
