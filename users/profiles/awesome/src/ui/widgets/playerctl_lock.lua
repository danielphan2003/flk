local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local create_button = function(symbol, color, command, playpause)

    local icon = wibox.widget {
        markup = helpers.colorize_text(symbol, color),
        font = beautiful.icon_font_name .. "20",
        align = "center",
        valigin = "center",
        widget = wibox.widget.textbox()
    }

    local button = wibox.widget {
        icon,
        forced_height = dpi(30),
        forced_width = dpi(30),
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

local title_widget = wibox.widget {
    markup = 'No Title',
    align = 'center',
    valign = 'center',
    ellipsize = 'middle',
    widget = wibox.widget.textbox
}

local artist_widget = wibox.widget {
    markup = 'No Artist',
    align = 'center',
    valign = 'center',
    ellipsize = 'middle',
    wrap = 'word_char',
    widget = wibox.widget.textbox
}

-- Get Song Info 
awesome.connect_signal("bling::playerctl::title_artist_album",
                       function(title, artist, _)

    title_widget:set_markup_silently('<span foreground="' ..
                                         beautiful.xforeground .. '"><b>' ..
                                         title .. '</b></span>')
    artist_widget:set_markup_silently('<span foreground="' ..
                                          beautiful.xforeground .. '"><i>' ..
                                          artist .. '</i></span>')
end)

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

local playerctl = wibox.widget {
    {
        {
            {title_widget, artist_widget, layout = wibox.layout.fixed.vertical},
            top = 20,
            left = 25,
            right = 25,
            widget = wibox.container.margin
        },
        {
            nil,
            {
                playerctl_prev_symbol,
                playerctl_play_symbol,
                playerctl_next_symbol,
                spacing = dpi(40),
                layout = wibox.layout.fixed.horizontal
            },
            nil,
            expand = "none",
            layout = wibox.layout.align.horizontal
        },
        layout = wibox.layout.flex.vertical
    },
    top = dpi(0),
    left = dpi(20),
    right = dpi(20),
    bottom = dpi(10),
    widget = wibox.container.margin
}

return playerctl
