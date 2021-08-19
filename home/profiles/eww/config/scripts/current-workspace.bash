#!/usr/bin/env bash

$(swaymsg -m -t subscribe '[ "workspace" ]' | jq '.change == "focus"') && swaymsg -t get_workspaces | jq '.[] | select(.focused).num'
