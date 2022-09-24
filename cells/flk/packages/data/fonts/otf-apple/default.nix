{
  stdenv,
  lib,
  fog,
  p7zip,
}:
stdenv.mkDerivation {
  name = "otf-apple";

  buildInputs = [p7zip];

  src = with fog; [
    sf-font-compact.src
    sf-font-pro.src
    sf-mono.src
    ny-font.src
  ];

  sourceRoot = "./";

  preUnpack = "mkdir fonts";

  unpackCmd = ''
    7z x $curSrc >/dev/null
    dir="$(find . -not \( -path ./fonts -prune \) -type d | sed -n 2p)"
    cd $dir 2>/dev/null
    7z x *.pkg >/dev/null
    7z x Payload~ >/dev/null
    mv Library/Fonts/*.otf ../fonts/
    cd ../
    rm -R $dir
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/opentype/{"SF Pro","SF Mono","SF Compact","New York"}
    cp -a fonts/SF-Pro*.otf "$out/share/fonts/opentype/SF Pro"
    cp -a fonts/SF-Mono*.otf "$out/share/fonts/opentype/SF Mono"
    cp -a fonts/SF-Compact*.otf "$out/share/fonts/opentype/SF Compact"
    cp -a fonts/NewYork*.otf "$out/share/fonts/opentype/New York"
  '';

  meta = with lib; {
    description = "Install SF and NY font on linux";
    maintainers = [maintainers.danielphan2003];
    license = licenses.unfree;
    platforms = platforms.all;
  };
}
