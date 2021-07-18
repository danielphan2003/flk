#!/usr/bin/env bash

HOST="${1:-$HOST}"

attr="$FLAKEROOT#$HOST"
nixos-rebuild --flake "$attr" "${@:2}"
