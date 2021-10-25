{ pkgs, ... }: {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      clang
      cmake
      gdb
      lldb
      ;
  };
}
