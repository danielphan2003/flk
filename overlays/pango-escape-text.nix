final: prev: {
  pango-escape-text =
    final.writers.writePython3 "pango-escape-text.py"
    {libraries = [final.python3Packages.pygobject3];} ''
      import sys
      from gi.repository import GLib

      print(GLib.markup_escape_text(' '.join(sys.argv[1:])))
    '';
}
