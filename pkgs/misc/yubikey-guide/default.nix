{
  runCommand,
  dan-nixpkgs,
  pandoc,
}: let
  inherit (dan-nixpkgs.yubikey-guide) pname src version;
in
  runCommand "${pname}-${version}.html"
  {
    inherit src;
    nativeBuildInputs = [pandoc];
    title = "YubiKey Guide";
  }
  ''
    ln -s $src/{*/,README.md} .
    pandoc README.md \
      --metadata title="$title" \
      --output "$out" \
      --include-in-header ${./header.html} \
      --include-before-body ${./before.html} \
      --include-after-body ${./after.html} \
      --highlight-style haddock \
      --self-contained
  ''
