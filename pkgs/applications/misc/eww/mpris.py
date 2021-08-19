#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p gobjectIntrospection playerctl -p "python3.withPackages(ps: [ ps.pygobject3 ])"
import json
import gi
import subprocess
gi.require_version('Playerctl', '2.0')
from gi.repository import Playerctl, GLib

manager = Playerctl.PlayerManager()

ICON_MAP = {
    "default": " ",
    "firefox": " ",
    "spotify": " "
}

button = """
@button@
"""

box = """
@box@
"""


def is_within_metadata(metadata, title, artist, status, value):
    if (status not in metadata):
        if (title not in metadata):
            if (artist not in metadata):
                if (value not in metadata):
                    return False
    return True


def is_equal_metadata(metadata, title, artist, status, value):
    if (status == metadata["status"]):
        if (title == metadata["title"]):
            if (artist == metadata["artist"]):
                if (value == metadata["value"]):
                    return True
    return False


class Mpris:

    def __init__(self):
        self.players = {}

    def lazy_player_update(self, player, final_metadata):
        player_name = player.props.player_name
        status = final_metadata["status"]
        title = final_metadata["title"]
        artist = final_metadata["artist"]
        value = final_metadata["value"]

        if player_name in self.players:
            prev_metadata = self.players[player_name]
            if is_within_metadata(prev_metadata, title, artist, status, value):
                if is_equal_metadata(prev_metadata, title, artist, status, value):
                    return

        self.players[player_name].update(final_metadata)
        self.on_track_change()

    def format_artist(self, player):
        if player["artist"] != "":
            if player["title"].find(player["artist"]) == -1:
                return ", by {}".format(player["artist"])
        return ""

    def init_player(self, name):
        if name.name != "":
            self.players[name.name] = {
                "title": "",
                "artist": "",
                "status": "",
                "value": ""
            }
            player = Playerctl.Player.new_from_name(name)
            player.connect(
                'playback-status::playing', self.on_playback_status, manager)
            player.connect(
                'playback-status::paused', self.on_playback_status, manager)
            player.connect(
                'playback-status::stop', self.on_playback_status, manager)
            player.connect(
                'metadata', self.on_metadata, manager)
            manager.manage_player(player)

    def on_playback_status(self, player, status, manager):
        player_name = player.props.player_name
        title = (player.get_title()).replace("'", "\'").replace("\"", "\\\"")
        artist = (player.get_artist()).replace("'", "\'").replace("\"", "\\\"")
        status_name = player.props.status.lower()

        final_metadata = {
            "title": title,
            "artist": artist,
            "status": status_name
        }

        final_metadata.update({
            "value": button.format(
                status = status_name,
                player = player_name,
                icon = ICON_MAP[player_name] if player_name in ICON_MAP.keys() else ICON_MAP["default"],
                title = title,
                artist = self.format_artist(final_metadata)
            )
        })

        self.lazy_player_update(player, final_metadata)

    def on_track_change(self):
        subprocess.check_output([
            "@eww@/bin/eww",
            "update",
            "mpris={}".format(box.format(
                button = " ".join([item[1]["value"] for item in self.players.items()])))
        ])

    def on_metadata(self, player, metadata, manager):
        keys = metadata.keys()

        player_name = player.props.player_name
        title = (metadata['xesam:title'] if 'xesam:title' in keys else "").replace("'", "\'").replace("\"", "\\\"")
        artist = (metadata['xesam:artist'][0] if 'xesam:artist' in keys else "").replace("'", "\'").replace("\"", "\\\"")
        status = player.props.status.lower()

        final_metadata = {
            "title": title,
            "artist": artist,
            "status": status
        }

        final_metadata.update({
            "value": button.format(
                status = status,
                player = player_name,
                icon = ICON_MAP[player_name] if player_name in ICON_MAP.keys() else ICON_MAP["default"],
                title = title,
                artist = self.format_artist(final_metadata)
            )
        })

        self.lazy_player_update(player, final_metadata)

    def on_name_appeared(self, manager, name):
        self.init_player(name)

    def on_player_vanished(self, manager, player):
        self.players.pop(player.props.player_name)
        self.on_track_change()


mpris = Mpris()

manager.connect('name-appeared', mpris.on_name_appeared)
manager.connect('player-vanished', mpris.on_player_vanished)

for name in manager.props.player_names:
    mpris.init_player(name)

main = GLib.MainLoop()
main.run()
