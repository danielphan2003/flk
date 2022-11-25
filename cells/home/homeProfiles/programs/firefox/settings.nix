{lib, ...}: let
  mkOption = enable: value: {inherit enable value;};

  enabled = mkOption true;
  disabled = mkOption false;

  explicit.enabled = enabled true;
  implicit.enabled = enabled false;

  explicit.disabled = disabled false;
  implicit.disabled = disabled true;
in {
  programs.firefox.profiles.default.settings = {
    "accessibility.typeaheadfind" = true;

    "app.update.auto" = false;

    "browser.backspace_action" = 2;

    # Dark theme devtools
    "devtools.theme" = "dark";

    # Stop creating ~/Downloads!
    "browser.download.dir" = "~/dl";

    # Show the bookmarks toolbar by default
    "browser.toolbars.bookmarks.visibility" = "always";

    # Force using WebRender. Improve performance
    "gfx.webrender.all" = true;
    "gfx.webrender.enabled" = true;

    # Enable SVG customization
    "svg.context-properties.content.enabled" = true;

    # Enable extra codecs
    # To prevent fingerprinting, arkenfox users should disable this.
    "image.jxl.enabled" = lib.mkDefault true;

    # Enable multi-pip
    "media.videocontrols.picture-in-picture.allow-multiple" = true;

    # Smooth scroll
    "general.smoothScroll.lines.durationMaxMS" = 125;
    "general.smoothScroll.lines.durationMinMS" = 125;
    "general.smoothScroll.mouseWheel.durationMaxMS" = 200;
    "general.smoothScroll.mouseWheel.durationMinMS" = 100;
    "general.smoothScroll.msdPhysics.enabled" = true;
    "general.smoothScroll.other.durationMaxMS" = 125;
    "general.smoothScroll.other.durationMinMS" = 125;
    "general.smoothScroll.pages.durationMaxMS" = 125;
    "general.smoothScroll.pages.durationMinMS" = 125;

    "mousewheel.min_line_scroll_amount" = 30;
    "mousewheel.system_scroll_override_on_root_content.enabled" = true;
    "mousewheel.system_scroll_override_on_root_content.horizontal.factor" = 175;
    "mousewheel.system_scroll_override_on_root_content.vertical.factor" = 175;
    "toolkit.scrollbox.horizontalScrollDistance" = 6;
    "toolkit.scrollbox.verticalScrollDistance" = 2;

    "startup.homepage_welcome_url" = "";
    "startup.homepage_welcome_url.additional" = "";
    "startup.homepage_override_url" = "";
    "browser.tabs.warnOnClose" = true;
    "browser.tabs.warnOnCloseOtherTabs" = true;
    "browser.tabs.warnOnOpen" = true;
    "browser.warnOnQuitShortcut" = true;
    "full-screen-api.warning.delay" = 0;
    "full-screen-api.warning.timeout" = 0;
    "browser.search.update" = true;
    "extensions.update.enabled" = true;
    "extensions.update.autoUpdateDefault" = true;
    "extensions.getAddons.cache.enabled" = true;
    "browser.download.autohideButton" = true;
    # Enable userContent.css and userChrome.css for our theme modules
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "ui.prefersReducedMotion" = 1;
    "ui.systemUsesDarkTheme" = 1;
    "clipboard.autocopy" = true;
    "layout.spellcheckDefault" = 2;
    "browser.quitShortcut.disabled" = true;
    "browser.tabs.closeWindowWithLastTab" = true;
    "browser.tabs.loadBookmarksInTabs" = true;
    "browser.urlbar.decodeURLsOnCopy" = true;
    # Enable auto scroll
    "general.autoScroll" = true;
    "ui.key.menuAccessKey" = 0;
    "view_source.tab" = true;
    "extensions.pocket.enabled" = true;
    "extensions.screenshots.disabled" = true;
    "identity.fxaccounts.enabled" = true;
    "reader.parse-on-load.enabled" = true;
    "browser.bookmarks.max_backups" = 2;
    "network.manage-offline-status" = true;
    "xpinstall.signatures.required" = true;
  };

  programs.firefox.profiles.default.arkenfox = {
    # resume previous session
    "0100"."0102"."browser.startup.page" = enabled 3;

    "0600"."0610"."browser.send_pings" = implicit.enabled;

    "0700"."0701"."network.dns.disableIPv6" = implicit.enabled;

    "0800" = {
      # TODO: use self hosted search engine
      "0801"."keyword.enabled" = explicit.enabled;

      "0804" = {
        "browser.search.suggest.enabled" = explicit.enabled;
        "browser.urlbar.suggest.searches" = explicit.enabled;
      };
    };

    "1400" = {
      # "1402" = {
      #   "layout.css.font-visibility.private" = enabled 1;
      #   "layout.css.font-visibility.standard" = enabled 1;
      #   "layout.css.font-visibility.trackingprotection" = enabled 1;
      # };
    };

    "1600"."1601"."network.http.referer.XOriginPolicy".value = 2;

    "2600"."2653"."browser.download.manager.addToRecentDocs" = explicit.enabled;

    "2800" = {
      "2811" = {
        "privacy.clearOnShutdown.downloads" = implicit.enabled;
        "privacy.clearOnShutdown.history" = implicit.enabled;
      };
    };

    # Don't use the built-in password manager; a nixos user is more likely
    # using an external one (you are using one, right?).
    "5000"."5003"."signon.rememberSignons" = implicit.enabled;

    "9000"."9000" = {};
  };
}
