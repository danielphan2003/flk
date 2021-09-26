{ lib, pkgs }:
{
  mc-motd = import ./mc-motd { inherit lib pkgs; };
}
