final: prev: {
  # i feel ashamed of myself
  multimc = prev.multimc.overrideAttrs (_: {
    inherit (final.sources.multimc-cracked) pname src version;
    # patches = [ ../pkgs/games/multimc/0001-pick-latest-java-first.patch ];
    # postPatch = ''
    #   # hardcode jdk paths
    #   substituteInPlace launcher/java/JavaUtils.cpp \
    #     --replace 'scanJavaDir("/usr/lib/jvm")' 'javas.append("${prev.jdk}/lib/openjdk/bin/java")' \
    #     --replace 'scanJavaDir("/usr/lib32/jvm")' 'javas.append("${prev.jdk8}/lib/openjdk/bin/java")'
    # '';
  });
}
