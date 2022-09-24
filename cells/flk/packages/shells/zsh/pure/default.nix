{
  stdenv,
  lib,
  fog,
}:
stdenv.mkDerivation {
  inherit (fog.pure) pname src version;

  buildPhase = "true";

  installPhase = ''
    mkdir -p $out/share/zsh/plugins/pure
    cp -r ./ $out/share/zsh/plugins/pure
  '';

  meta = with lib; {
    description = "Pretty, minimal and fast ZSH prompt";
    homepage = "https://github.com/sindresorhus/pure";
    maintainers = [maintainers.danielphan2003];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
