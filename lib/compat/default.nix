let
  rev = "b4a34015c698c7793d592d66adbab377907a2be8";
  flake =
    import
    (
      fetchTarball {
        url = "https://github.com/edolstra/flake-compat/archive/${rev}.tar.gz";
        sha256 = "0zd3x46fswh5n6faq4x2kkpy6p3c6j593xbdlbsl40ppkclwc80x";
      }
    )
    {
      src = ../../.;
    };
in
  flake
