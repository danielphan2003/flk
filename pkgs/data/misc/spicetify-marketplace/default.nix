{
  lib,
  nodejs,
  stdenv,
  fetchurl,
  writeText,
  git,
  cacert,
  dan-nixpkgs,
  yarnPluginNixify ? import ./yarn-plugin-nixify.nix {inherit lib nodejs stdenv fetchurl writeText git cacert;},
}:
yarnPluginNixify.build {
  inherit (dan-nixpkgs.spicetify-marketplace) pname src version;

  offlineCache = import ./yarn.lock.nix;

  buildPhase = ''
    yarn workspace @spicetify/marketplace build:prod --offline
  '';

  installPhase = ''
    mkdir -p $out/custom_apps

    cp -a packages/marketplace/dist/. $out/custom_apps
  '';

  meta = with lib; {
    description = "Download extensions and themes directly from Spicetify";
    homepage = "https://github.com/spicetify/spicetify-marketplace";
    maintainers = [maintainers.danielphan2003];
    platforms = platforms.all;
  };
}
