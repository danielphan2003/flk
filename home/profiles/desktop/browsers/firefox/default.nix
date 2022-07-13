{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) fileContents mkAfter;
  inherit (lib.our) mkFirefoxConfig;

  firefoxConfig = import ./settings.nix;
  mozPath = ".mozilla";
  cfgPath = "${mozPath}/firefox";
in {
  home.packages = with pkgs; [firefox-nightly-bin];

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
      Path=${config.home.username}.default
      Default=1
      [General]
      StartWithLastProfile=1
      Version=2
    '';

    "${cfgPath}/${config.home.username}.default/user.js" = {
      text = mkFirefoxConfig {
        inherit firefoxConfig;
        extraConfig = "${fileContents "${pkgs.arkenfox-userjs}/share/firefox/user.js"}";
      };
    };

    "${cfgPath}/${config.home.username}.default/chrome/userChrome.css".source = ./userChrome.css;

    # "${cfgPath}/${config.home.username}.default/chrome" = {
    #   source = "${pkgs.flyingfox}/chrome";
    #   recursive = true;
    # };

    # "${cfgPath}/${config.home.username}.default/chrome/userChrome.css".source =
    #   mkAfter "${pkgs.pywalfox}/share/pywalfox/userChrome.css";

    # "${cfgPath}/${config.home.username}.default/chrome/userContent.css".source =
    #   mkAfter "${pkgs.pywalfox}/share/pywalfox/userContent.css";

    "${mozPath}/native-messaging-hosts/pywalfox.json".source = "${pkgs.pywalfox}/lib/mozilla/native-messaging-hosts/pywalfox.json";

    # "${mozPath}/native-messaging-hosts/fx_cast_bridge.json".source = "${pkgs.fx_cast_bridg}/lib/mozilla/native-messaging-hosts/fx_cast_bridge.json";
  };
}
