{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) attrValues readFile;
in {
  environment = {
    etc."xdg/qutebrowser/config.py".text = let
      mpv = "${pkgs.mpv}/bin/mpv";
    in ''
      ${readFile ./config.py}
      ${
        lib.optionalString
        (config.networking.extraHosts != "")
        "c.content.blocking.enabled = False"
      }
      ${lib.optionalString (pkgs.system == "x86_64-linux") "c.qt.args.append('widevine-path=${pkgs.widevine-cdm}/lib/libwidevinecdm.so')"}
      config.bind(',m', 'hint links spawn -d ${mpv} {hint-url}')
      config.bind(',v', 'spawn -d ${mpv} {url}')
    '';

    # sessionVariables.BROWSER = "qute";

    systemPackages = attrValues {
      inherit
        (pkgs)
        qute
        qutebrowser
        mpv
        youtube-dl
        ;
    };
  };
}
