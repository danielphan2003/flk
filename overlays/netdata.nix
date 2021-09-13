channels: final: prev: {
  netdata = with channels.latest; netdata.overrideAttrs (o:
    let
      go-d-plugin = callPackage ../pkgs/tools/system/netdata/go.d.plugin.nix { inherit (final) sources; };
    in
    {
      inherit (final.sources.netdata) pname src version;
      patches = lib.our.getPatches ../pkgs/tools/system/netdata;
      buildInputs = o.buildInputs
        ++ lib.optionals (!stdenv.isDarwin) [ protobuf ];
      postInstall = ''
        ln -s ${go-d-plugin}/lib/netdata/conf.d/* $out/lib/netdata/conf.d
        ln -s ${go-d-plugin}/bin/godplugin $out/libexec/netdata/plugins.d/go.d.plugin
      '' + lib.optionalString (!stdenv.isDarwin) ''
        # rename this plugin so netdata will look for setuid wrapper
        mv $out/libexec/netdata/plugins.d/apps.plugin \
          $out/libexec/netdata/plugins.d/apps.plugin.org
        mv $out/libexec/netdata/plugins.d/cgroup-network \
          $out/libexec/netdata/plugins.d/cgroup-network.org
        mv $out/libexec/netdata/plugins.d/perf.plugin \
          $out/libexec/netdata/plugins.d/perf.plugin.org
        mv $out/libexec/netdata/plugins.d/slabinfo.plugin \
          $out/libexec/netdata/plugins.d/slabinfo.plugin.org
        ${lib.optionalString (!stdenv.isDarwin) ''
          mv $out/libexec/netdata/plugins.d/freeipmi.plugin \
            $out/libexec/netdata/plugins.d/freeipmi.plugin.org
        ''}
      '';
    });
}
