final: prev: {
  papermc = prev.papermc.overrideAttrs (_: {
    inherit (final.sources.papermc) pname src;
    version = "1.17.1r${final.sources.papermc.version}";
  });
}
