{
  writeShellApplication,
  dan-nixpkgs,
  openjdk17,
}:
writeShellApplication {
  name = "revanced-cli";
  runtimeInputs = [openjdk17];
  text = ''
    java -jar \
      ${dan-nixpkgs.revanced-cli.src} \
      --merge ${dan-nixpkgs.revanced-integrations.src} \
      --bundles ${dan-nixpkgs.revanced-patches-jar.src} \
      "$@"
  '';
}
