{
  lib,
  stdenv,
  writeText,
  pywalfox,
  sources,
}: let
  auto_hide_tst = writeText "auto-hide-tst.css" ''
    /* Hide main tabs toolbar */
    #main-window[tabsintitlebar="true"]:not([extradragspace="true"]) #TabsToolbar > .toolbar-items {
        opacity: 0;
        pointer-events: none;
    }
    #main-window:not([tabsintitlebar="true"]) #TabsToolbar {
        visibility: collapse !important;
    }

    /* Sidebar min and max width removal */
    #sidebar {
        max-width: none !important;
        min-width: 0px !important;
    }
    /* Hide splitter, when using Tree Style Tab. */
    #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] + #sidebar-splitter {
        display: none !important;
    }
    /* Hide sidebar header, when using Tree Style Tab. */
    #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
        visibility: collapse;
    }

    /* Shrink sidebar until hovered, when using Tree Style Tab. */
    :root {
        --thin-tab-width: 30px;
        --wide-tab-width: 200px;
    }
    #sidebar-box:not([sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"]) {
        min-width: var(--wide-tab-width) !important;
        max-width: none !important;
    }
    #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] {
        position: relative !important;
        transition: all 100ms !important;
        min-width: var(--thin-tab-width) !important;
        max-width: var(--thin-tab-width) !important;
    }
    #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"]:hover {
        transition: all 200ms !important;
        min-width: var(--wide-tab-width) !important;
        max-width: var(--wide-tab-width) !important;
        margin-right: calc((var(--wide-tab-width) - var(--thin-tab-width)) * -1) !important;
        z-index: 1;
    }
  '';

  dim_unload_tab = writeText "dim-unload-tab.css" ''
    /**
    * @name Dim Unloaded Tabs
    * @author Niklas Gollenstede
    * @licence CC-BY-SA-4.0 or MIT or MPL 2.0
    * @description
    *     This style dims not loaded tabs in Firefox.
    *     It is complementary to the UnloadTabs WebExtension and can either:
    *     * be manually added to the `chrome/user.chrome.css` file in Firefox's profile directory
    *     * or installed with the reStyle Firefox extension (and NativeExt).
    *
    *     If you have any issues with this style, please open a ticket at https://github.com/NiklasGollenstede/unload-tabs
    */

    @-moz-document
        url(chrome://browser/content/browser.xhtml),
        url(chrome://browser/content/browser.xul)
    {
        tab[pending], #alltabs-popup menuitem[pending]
        {
            opacity: 0.6 !important;
        }
    }
  '';
in
  stdenv.mkDerivation {
    inherit (sources.flyingfox) pname src version;
    inherit auto_hide_tst dim_unload_tab;

    pywalfox_css = "${pywalfox.out}/chrome";

    installPhase = ''
      cp -r ./ $out
      cat $dim_unload_tab >> $out/chrome/userChrome.css
      cat $pywalfox_css/userChrome.css >> $out/chrome/userChrome.css
      # cat $auto_hide_tst >> $out/chrome/userChrome.css
      cat $pywalfox_css/userContent.css >> $out/chrome/userContent.css
    '';

    patches = [./no-tabline.patch];

    meta = with lib; {
      description = "An opinionated set of configurations for firefox";
      homepage = "https://flyingfox.netlify.app";
      license = licenses.mit;
      maintainers = [danielphan2003];
      platforms = platforms.all;
    };
  }
