{ stdenv, lib, srcs }:
let inherit (srcs) pure; in
stdenv.mkDerivation {
  pname = "pure";

  inherit (pure) version;

  src = pure;

  buildPhase = "true";

  installPhase = ''
    mkdir -p $out/share/zsh/plugins/pure
    cp -r ./ $out/share/zsh/plugins/pure
  '';

  meta = with lib; {
    description = "Pretty, minimal and fast ZSH prompt";
    homepage = "https://github.com/sindresorhus/pure";
    maintainers = [ maintainers.nrdxp ];
    platforms = platforms.unix;
    license = licenses.mit;
    inherit version;
  };
}
