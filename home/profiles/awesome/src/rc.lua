-- rc.lua
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gfs = require("gears.filesystem")
local awful = require("awful")
require("awful.autofocus")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")

local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title = "Oops, an error happened" ..
            (startup and " during startup!" or "!"),
        message = message
    }
end)

-- Initialize Theme
local theme = "ghosts"
beautiful.init(gfs.get_configuration_dir() .. "theme/" .. theme .. "/theme.lua")

-- Import Configuration
require("configuration")

-- Screen Padding and Tags
screen.connect_signal("request::desktop_decoration", function(s)
    -- Screen padding
    screen[s].padding = {left = 0, right = 0, top = 0, bottom = 0}
    -- Each screen has its own tag table.
    awful.tag({"1", "2", "3", "4", "5"}, s, awful.layout.layouts[1])
end)

-- Import Daemons and Widgets
require("signal")
require("ui")

-- Create a launcher widget and a main menu
awesomemenu = {
    {
        "Key Binds",
        function() hotkeys_popup.show_help(nil, awful.screen.focused()) end
    }, {"Manual", terminal .. " start man awesome"},
    {"Edit Config", editor .. " " .. awesome.conffile},
    {"Restart", awesome.restart}, {"Quit", function() awesome.quit() end}
}

appmenu = {{"Alacritty", terminal}, {"Codium", editor}}

mymainmenu = awful.menu({
    items = {
        {"AwesomeWM", awesomemenu, beautiful.awesome_icon}, {"Apps", appmenu}
    }
})

awful.mouse.append_global_mousebindings({
    awful.button({}, 3, function() mymainmenu:toggle() end)
})

-- Garbage Collector Settings
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

-- Use the following for a less intense, more battery saving GC
-- collectgarbage("setpause", 160)
-- collectgarbage("setstepmul", 400)

--
-- This is the code for the floating music player.
--
--[[
local wibox = require("wibox")
local helpers = require("helpers")
local gears = require("gears")
local create_button = function(symbol, color, command, playpause)
    local icon = wibox.widget {
        markup = helpers.colorize_text(symbol, color),
        font = "FiraCode Nerd Font Mono 20",
        align = "center",
        valigin = "center",
        widget = wibox.widget.textbox()
    }
    local button = wibox.widget {
        icon,
        forced_height = 30,
        forced_width = 30,
        widget = wibox.container.background
    }
    awesome.connect_signal("bling::playerctl::status", function(playing)
        if playpause then
            if playing then
                icon.markup = helpers.colorize_text("", color)
            else
                icon.markup = helpers.colorize_text("", color)
            end
        end
    end)
    button:buttons(gears.table.join(
                        awful.button({}, 1, function() command() end)))
    button:connect_signal("mouse::enter", function()
        icon.markup = helpers.colorize_text(icon.text, beautiful.xforeground)
    end)
    button:connect_signal("mouse::leave", function()
        icon.markup = helpers.colorize_text(icon.text, color)
    end)
    return button
end
local play_command =
    function() awful.spawn.with_shell("playerctl play-pause") end
local prev_command = function() awful.spawn.with_shell("playerctl previous") end
local next_command = function() awful.spawn.with_shell("playerctl next") end
local playerctl_play_symbol = create_button("", beautiful.xcolor4,
                                            play_command, true)
local playerctl_prev_symbol = create_button("玲", beautiful.xcolor4,
                                            prev_command, false)
local playerctl_next_symbol = create_button("怜", beautiful.xcolor4,
                                            next_command, false)
local art = wibox.widget {
    image = gfs.get_configuration_dir() .. "images/me.png",
    resize = true,
    forced_height = 200,
    forced_width = 200,
    -- clip_shape = helpers.rrect(12),
    widget = wibox.widget.imagebox
}
awesome.connect_signal("bling::playerctl::title_artist_album",
                        function(_, _, art_path)
    -- Set art widget
    art:set_image(gears.surface.load_uncached(art_path))
end)
local draggable_player = wibox({
    visible = true,
    ontop = true,
    width = 200,
    height = 265,
    bg = beautiful.xbackground .. 00,
    widget = {
        {
            art,
            bg = beautiful.xbackground .. 00,
            shape = helpers.rrect(12),
            border_width = beautiful.widget_border_width + 1,
            border_color = beautiful.widget_border_color,
            widget = wibox.container.background
        },
        helpers.vertical_pad(15),
        {
            {
                playerctl_prev_symbol,
                playerctl_play_symbol,
                playerctl_next_symbol,
                layout = wibox.layout.flex.horizontal
            },
            forced_height = 50,
            bg = beautiful.xcolor0,
            shape = helpers.rrect(12),
            widget = wibox.container.background
        },
        layout = wibox.layout.fixed.vertical
    }
})
draggable_player:connect_signal("mouse::enter", function()
    awful.mouse.wibox.move(draggable_player)
end)
]] --

-- EOF ------------------------------------------------------------------------
