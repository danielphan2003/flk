{
  inputs,
  cell
}: {
  flk-lib = final: prev: {
    __dontExport = true;
    lib = prev.lib.extend (lfinal: lprev: {
      flk = cells.flk.lib;
    });
  };
}
