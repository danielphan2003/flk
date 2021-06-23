final: prev:
let 
  python = prev.python3.buildEnv.override {
    extraLibs = with prev.python3Packages; [ pygobject3 ];
  };
in 
{
  pango-escape-text = prev.writeScript "pango-escape-text.py" ''
    #!${python}/bin/python

    import sys
    import gi
    from gi.repository import GLib

    print(GLib.markup_escape_text(' '.join(sys.argv[1:])))
  '';
}