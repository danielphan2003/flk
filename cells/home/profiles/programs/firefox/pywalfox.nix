{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) fileContents mkAfter;

  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  mozillaConfigPath =
    if isDarwin
    then "Library/Application Support/Mozilla"
    else ".mozilla";
in {
  home.packages = [pkgs.pywalfox];

  programs.firefox.profiles.default = {
    # userChrome = mkAfter (fileContents "${pkgs.pywalfox}/share/pywalfox/userChrome.css");

    # userContent = mkAfter (fileContents "${pkgs.pywalfox}/share/pywalfox/userContent.css");
  };

  home.file."${mozillaConfigPath}/native-messaging-hosts/pywalfox.json".source = "${pkgs.pywalfox}/lib/mozilla/native-messaging-hosts/pywalfox.json";
}
