{
  # Dark theme devtools
  "devtools.theme" = "dark";

  # Enable userContent.css and userChrome.css for our theme modules
  "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

  # Stop creating ~/Downloads!
  "browser.download.dir" = "/home/danie/dl";

  # Don't use the built-in password manager; a nixos user is more likely
  # using an external one (you are using one, right?).
  "signon.rememberSignons" = false;

  # Show the bookmarks toolbar by default
  "browser.toolbars.bookmarks.visibility" = "always";

  # Disable checking if Firefox is the default browser
  "browser.shell.checkDefaultBrowser" = false;

  /* override recipe: FF87+ use ETP Strict mode ***/
  "privacy.firstparty.isolate" = false; # 4001
  "network.cookie.cookieBehavior" = 5; # 2701
  "browser.contentblocking.category" = "strict"; # 2701

  # Enable auto scroll
  "general.autoScroll" = true;

  # Force using WebRender. Improve performance
  "gfx.webrender.all" = true;
  "gfx.webrender.enabled" = true;

  # Enable SVG customization
  "svg.context-properties.content.enabled" = true;
  "svg.disabled" = false;

  # CSS extras
  "layout.css.backdrop-filter.enabled" = true;
  "layout.css.constructable-stylesheets.enabled" = true;

  # Enable extra codecs
  "image.avif.enabled" = true;
  "image.jxl.enabled" = true;
  "media.ffmpeg.vaapi.enabled" = true;
  "media.ffvpx.enabled" = false;
  "media.rdd-vpx.enabled" = false;

  /* override recipe: enable DRM and let me watch videos ***/
  # "media.gmp-widevinecdm.enabled" = true; # 1825 default commented out in user.js v86+
  "media.eme.enabled" = true; # 1830

  /* override recipe: enable session restore ***/
  "browser.startup.page" = 0; # 0102
  "browser.startup.homepage" = "moz-extension://fd275aeb-de2b-4a12-80b1-2f62e656d78c/index.html";
  "browser.newtabpage.enabled" = "moz-extension://fd275aeb-de2b-4a12-80b1-2f62e656d78c/index.html";
  "browser.newtab.preload" = true;
  # "browser.privatebrowsing.autostart" = false; # 0110 required if you had it set as true
  # "places.history.enabled" = true; # 0862 required if you had it set as false
  # "browser.sessionstore.privacy_level" = 0; # 1021 optional [to restore cookies/formdata]
  # "privacy.clearOnShutdown.cookies" = false; # 2803 optional
  # "privacy.clearOnShutdown.formdata" = false; # 2803 optional
  "privacy.cpd.history" = false; # 2804 to match when you use Ctrl-Shift-Del
  # "privacy.cpd.cookies" = false; # 2804 optional
  # "privacy.cpd.formdata" = false; # 2804 optional

  /* override recipe: enable web conferencing: Google Meet | JitsiMeet | BigBlueButton | Zoom | Discord ***/
  # IMPORTANT: uncheck "Prevent WebRTC from leaking local IP addresses" in uBlock Origin's settings
  # NOTE: if using RFP (4501)
  # some sites, e.g. Zoom, need a canvas site exception [Right Click>View Page Info>Permissions]
  # Discord video does not work: it thinks you are FF78: use a separate profile or spoof the user agent
  "media.peerconnection.enabled" = true; # 2001
  "media.peerconnection.ice.no_host" = false; # 2001 [may or may not be required]
  "webgl.disabled" = false; # 2010 [required for Zoom]
  # "webgl.min_capability_mode" = false; # 2012 [removed from the user.js in v88 - reset it]
  "media.getusermedia.screensharing.enabled" = true; # 2022 optional
  "media.getusermedia.browser.enabled" = true;
  "media.getusermedia.audiocapture.enabled" = true;
  # "media.autoplay.blocking_policy" = 0; # 2031 optional [otherwise add site exceptions]
  "javascript.options.wasm" = true; # 2422 optional [some platforms may require this]
  "dom.webaudio.enabled" = true; # 2510

  "privacy.clearOnShutdown.cache" = false;
  "privacy.clearOnShutdown.cookies" = false;
  "privacy.clearOnShutdown.downloads" = false; # see note above
  "privacy.clearOnShutdown.history" = false; # Browsing & Download History
  "privacy.clearOnShutdown.offlineApps" = false; # Offline Website Data
  "privacy.clearOnShutdown.sessions" = false; # Active Logins
  "privacy.clearOnShutdown.siteSettings" = false; # Site Preferences

  # Enable multi-pip
  "media.videocontrols.picture-in-picture.allow-multiple" = true;

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

  "keyword.enabled" = true;
  "keyword.url" = "https://duckduckgo.com/?q=\\";
  "browser.search.suggest.enabled" = true;
  "browser.urlbar.suggest.searches" = true;
  "browser.urlbar.placeholderName" = "DuckDuckGo";
  "browser.urlbar.placeholderName.private" = "DuckDuckGo";

  "browser.download.manager.addToRecentDocs" = true;

  "media.getusermedia.aec_enabled" = false;
  "media.getusermedia.agc_enabled" = false;
  "media.getusermedia.noise_enabled" = false;
  "media.getusermedia.hpf_enabled" = false;

  "browser.ssb.enabled" = true;

  "network.dns.disableIPv6" = false;
  "network.http.referer.XOriginPolicy" = 0;
}
