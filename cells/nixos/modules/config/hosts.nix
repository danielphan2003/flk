{
  self,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  inherit
    (config.networking)
    hostName
    ;

  cfg = config.flk;

  sharedOpts = {
    domain = mkOption {
      type = types.str;
      description = "Domain name that this machine belongs to.";
    };

    tailscale = {
      magicdns = tsDomainSharedOpts "MagicDNS" {
        suffix.default = "beta.tailscale.net";
        domain.default = cfg.shared.domain or config.networking.domain;
      };

      https = tsDomainSharedOpts "HTTPS" {
        suffix.default = "ts.net";
        domain.default = "tailnet-*";
      };
    };
  };

  singleHostOpts =
    sharedOpts
    // {
      name = mkOption {
        type = types.str;
        description = "Host name";
      };

      gateway = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Gateways that this machine usually connects to.";
      };

      address = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Addresses that are assigned to this machine.";
      };

      tailscale = {
        ip = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Tailscale IPv4 address of current machine";
        };

        ipv6 = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Tailscale IPv6 address of current machine";
        };

        magicdns = tsDomainOpts "MagicDNS";

        https = tsDomainOpts "HTTPS";
      };

      publicKeys = {
        ssh = mkOption {
          type = types.listOf types.str;
          default = [];
          description = "Public SSH key of this machine.";
        };

        binaryCache = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Public binary cache key of this machine.";
        };
      };

      tags = mkOption {
        type = types.listOf (types.enum [
          "device_audio"
          "device_camera"
          "device_gameconsole"
          "device_laptop"
          "device_nas"
          "device_pc"
          "device_phone"
          "device_printer"
          "device_securityalarm"
          "device_tablet"
          "device_tv"
          "device_other"

          "os_android"
          "os_ios"
          "os_linux"
          "os_macos"
          "os_windows"
          "os_other"

          "user_admin"
          "user_regular"
          "user_child"
        ]);
        default = [];
        description = "Tags that this machine belongs to.";
      };

      type = mkOption {
        type = types.enum ["ephemeral" "permanant"];
        default = "permanant";
        description = "Type of this machine.";
      };

      managed = mkOption {
        type = types.bool;
        description = "Whether this device is managed via NixOS and flk.";
      };
    };

  hostOpts = types.submodule ({
    name,
    config,
    ...
  }: {
    options = singleHostOpts;

    config = {
      name = mkDefault name;

      domain = mkDefault config.name;

      tailscale = {
        magicdns.machineName = mkDefault config.name;
        https.machineName = mkDefault config.name;
      };
    };
  });

  tsDomainSharedOpts = type: defaultsOpts: let
    typeCfg = cfg.currentHost.tailscale."${toLower type}";
  in
    recursiveUpdate defaultsOpts {
      suffix = mkOption {
        type = types.str;
        description = "Tailscale ${type} suffix of your tailnet";
      };

      domain = mkOption {
        type = types.nullOr types.str;
        description = "Tailscale ${type} domain of your tailnet";
      };
    };

  tsDomainOpts = type: let
    sharedTypeCfg = cfg.shared.tailscale."${toLower type}";
    typeCfg = cfg.currentHost.tailscale."${toLower type}";
  in
    tsDomainSharedOpts type {
      suffix.default = sharedTypeCfg.suffix;
      domain.default = sharedTypeCfg.domain;
    }
    // {
      machineName = mkOption {
        type = types.str;
        default = hostName;
        description = "Machine name for Tailscale ${type}";
      };

      fqdn = mkOption {
        type = types.str;
        default = "${typeCfg.machineName}.${typeCfg.domain}.${typeCfg.suffix}";
        description = "Fully qualified Tailscale ${type} domain name of your machine";
      };
    };
in {
  options.flk = {
    shared = sharedOpts;

    currentHost = singleHostOpts;

    hosts = mkOption {
      type = types.attrsOf hostOpts;
      default = {};
      description = ''
        Definitions of all hosts, with additional infos.
      '';
    };
  };

  config = {
    flk.currentHost = recursiveUpdate cfg.shared (cfg.hosts."${hostName}" or {});

    networking.domain = cfg.shared.domain or cfg.currentHost.domain;

    deployment = mkIf cfg.currentHost.managed {
      targetHost = mkDefault cfg.currentHost.tailscale.ipv6;
      targetPort = mkDefault 22;
      targetUser = mkDefault config.users.users.root.name;
    };
  };
}
