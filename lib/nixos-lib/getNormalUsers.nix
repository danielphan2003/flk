{ lib, config, ... }:
builtins.attrNames (lib.filterAttrs (n: v: v.isNormalUser) config.users.users)
