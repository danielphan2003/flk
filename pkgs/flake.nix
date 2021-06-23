{
  description = "Package Sources";

  inputs = {
    any-nix-shell.url = "github:haslersn/any-nix-shell";
    any-nix-shell.flake = false;
    awesome.url = "github:awesomeWM/awesome";
    awesome.flake = false;
    awestore.url = "github:K4rakara/awestore";
    awestore.flake = false;
    bling.url = "github:BlingCorp/bling";
    bling.flake = false;
    caddy.url = "github:caddyserver/caddy/v2.4.1";
    caddy.flake = false;
    droidcam.url = "github:aramg/droidcam/v1.7.1";
    droidcam.flake = false;
    dwall-improved.url = "github:GitGangGuy/dynamic-wallpaper-improved";
    dwall-improved.flake = false;
    flyingfox.url = "github:akshat46/FlyingFox";
    flyingfox.flake = false;
    ibus-bamboo.url = "github:BambooEngine/ibus-bamboo/v0.7.5-RC2";
    ibus-bamboo.flake = false;
    layout-machi.url = "github:xinhaoyuan/layout-machi";
    layout-machi.flake = false;
    libinih.url = "github:benhoyt/inih/r53";
    libinih.flake = false;
    lua-pam.url = "github:RMTT/lua-pam";
    lua-pam.flake = false;
    nix-zsh-completions.url = "github:Ma27/nix-zsh-completions";
    nix-zsh-completions.flake = false;
    picom.url = "github:yshui/picom";
    picom.flake = false;
    pure.url = "github:sindresorhus/pure";
    pure.flake = false;
    rainfox.url = "github:1280px/rainfox";
    rainfox.flake = false;
    redshift.url = "github:minus7/redshift/wayland";
    redshift.flake = false;
    retroarch.url = "github:libretro/retroarch/v1.9.0";
    retroarch.flake = false;
    rnix-lsp.url = "github:nix-community/rnix-lsp";
    rnix-lsp.flake = false;
    sddm-chili.url = "github:MarianArlt/sddm-chili/0.1.5";
    sddm-chili.flake = false;
    spicetify-cli.url = "github:khanhas/spicetify-cli/v1.2.1";
    spicetify-cli.flake = false;
    spicetify-themes.url = "github:morpheusthewhite/spicetify-themes";
    spicetify-themes.flake = false;
    steamcompmgr.url = "github:gamer-os/steamos-compositor-plus";
    steamcompmgr.flake = false;
    sway.url = "github:swaywm/sway";
    sway.flake = false;
    sway-borders.url = "github:fluix-dev/sway-borders";
    sway-borders.flake = false;
    udiskie.url = "github:coldfix/udiskie";
    udiskie.flake = false;
    user-js.url = "github:arkenfox/user.js";
    user-js.flake = false;
    xdg-desktop-portal-wlr.url = "github:emersion/xdg-desktop-portal-wlr";
    xdg-desktop-portal-wlr.flake = false;
    waycorner.url = "github:AndreasBackx/waycorner/0.1.3";
    waycorner.flake = false;
    whitesur-gtk-theme.url = "github:vinceliuice/whitesur-gtk-theme/2021-01-15";
    whitesur-gtk-theme.flake = false;
    whitesur-icon-theme.url = "github:vinceliuice/whitesur-icon-theme/2020-10-11";
    whitesur-icon-theme.flake = false;
    wii-u-gc-adapter.url = "github:ToadKing/wii-u-gc-adapter";
    wii-u-gc-adapter.flake = false;
    wine-staging.url = "github:wine-staging/wine-staging";
    wine-staging.flake = false;
    winetricks.url = "github:Winetricks/winetricks";
    winetricks.flake = false;
    wl-clipboard.url = "github:bugaevc/wl-clipboard";
    wl-clipboard.flake = false;
    wlroots.url = "github:swaywm/wlroots";
    wlroots.flake = false;
  };

  outputs = { self, nixpkgs, ... }: {
    overlay = final: prev: {
      inherit (self) srcs;
    };

    srcs =
      let
        inherit (nixpkgs) lib;

        mkVersion = name: input:
          let
            inputs = (builtins.fromJSON
              (builtins.readFile ./flake.lock)).nodes;

            ref =
              if lib.hasAttrByPath [ name "original" "ref" ] inputs
              then inputs.${name}.original.ref
              else "";

            version =
              let version' = builtins.match
                "[[:alpha:]]*[-._]?([0-9]+(\.[0-9]+)*)+"
                ref;
              in
              if lib.isList version'
              then lib.head version'
              else if input ? lastModifiedDate && input ? shortRev
              then "${lib.substring 0 8 input.lastModifiedDate}_${input.shortRev}"
              else null;
          in
          version;
      in
      lib.mapAttrs
        (pname: input:
          let
            version = mkVersion pname input;
          in
          input // { inherit pname; }
          // lib.optionalAttrs (! isNull version)
            {
              inherit version;
            }
        )
        (lib.filterAttrs (n: _: n != "nixpkgs")
          self.inputs);
  };
}
