args@{ pkgs, lib, ... }:
let
  modules-left = import ./left args;
  modules-center = import ./center args;
  modules-right = import ./right args;
in
lib.recursiveUpdate
  (lib.recursiveUpdate modules-left modules-center)
  modules-right
