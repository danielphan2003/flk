{
  writeShellApplication,
  fog,
  openjdk17,
}:
writeShellApplication {
  name = "revanced-cli";
  runtimeInputs = [openjdk17];
  text = ''
    java -jar \
      ${fog.revanced-cli.src} \
      --merge ${fog.revanced-integrations.src} \
      --bundles ${fog.revanced-patches-jar.src} \
      "$@"
  '';
}
