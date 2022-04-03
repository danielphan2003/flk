{
  lib,
  npmlock2nix,
  sources,
  python3,
}:
npmlock2nix.build {
  inherit (sources.lightcord) src;

  installPhase = "cp -r dist $out";

  node_modules_attrs = {
    buildInputs = [python3];
  };

  buildCommands = ["npm run build"];

  meta = with lib; {
    homepage = "https://github.com/Lightcord/Lightcord";
    description = "A simple - customizable - Discord Client";
    licenses = licenses.mit;
    maintainers = [maintainers.danielphan2003];
  };
}
