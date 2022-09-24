{pkgs, ...}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  mozillaConfigPath =
    if isDarwin
    then "Library/Application Support/Mozilla"
    else ".mozilla";
in {
  home.file = {
    "${mozillaConfigPath}/native-messaging-hosts/fx_cast_bridge.json".source = "${pkgs.fx_cast_bridge}/lib/mozilla/native-messaging-hosts/fx_cast_bridge.json";
  };
}
