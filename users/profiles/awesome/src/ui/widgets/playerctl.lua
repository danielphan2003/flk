local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local art = wibox.widget {
    image = gears.filesystem.get_configuration_dir() .. "images/no_music.png",
    resize = true,
    forced_height = dpi(100),
    -- forced_width = dpi(80),
    -- clip_shape = helpers.rrect(beautiful.border_radius - 5),
    widget = wibox.widget.imagebox
}

local create_button = function(symbol, color, command, playpause)

    local icon = wibox.widget {
        markup = helpers.colorize_text(symbol, color),
        font = beautiful.icon_font_name .. "15",
        align = "center",
        valigin = "center",
        widget = wibox.widget.textbox()
    }

    local button = wibox.widget {
        icon,
        forced_height = dpi(15),
        forced_width = dpi(15),
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
    forced_height = dpi(12),
    widget = wibox.widget.textbox
}

local artist_widget = wibox.widget {
    markup = 'No Artist',
    align = 'center',
    valign = 'center',
    ellipsize = 'middle',
    forced_height = dpi(12),
    widget = wibox.widget.textbox
}

-- Get Song Info 
awesome.connect_signal("bling::playerctl::title_artist_album",
                       function(title, artist, art_path)
    -- Set art widget
    art:set_image(gears.surface.load_uncached(art_path))

    title_widget:set_markup_silently(
        '<span foreground="' .. beautiful.xcolor5 .. '">' .. title .. '</span>')
    artist_widget:set_markup_silently(
        '<span foreground="' .. beautiful.xcolor6 .. '">' .. artist .. '</span>')
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

local slider = wibox.widget {
    forced_height = dpi(5),
    bar_shape = helpers.rrect(beautiful.border_radius),
    shape = helpers.rrect(beautiful.border_radius),
    background_color = beautiful.xcolor0 .. 55,
    color = beautiful.xcolor6,
    value = 25,
    max_value = 100,
    widget = wibox.widget.progressbar
}

awesome.connect_signal("bling::playerctl::position", function(pos, length)
    slider.value = (pos / length) * 100
end)

local playerctl = wibox.widget {
    {
        {
            art,
            bg = beautiful.xcolor0,
            -- shape = helpers.rrect(beautiful.border_radius - 5),
            widget = wibox.container.background
        },
        left = dpi(0),
        top = dpi(0),
        bottom = dpi(0),
        layout = wibox.container.margin
    },
    {
        {
            {
                {
                    title_widget,
                    artist_widget,
                    layout = wibox.layout.fixed.vertical
                },
                top = 10,
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
            {
                slider,
                top = dpi(10),
                left = dpi(25),
                right = dpi(25),
                widget = wibox.container.margin
            },
            layout = wibox.layout.align.vertical
        },
        top = dpi(0),
        bottom = dpi(10),
        widget = wibox.container.margin
    },
    layout = wibox.layout.align.horizontal
}

return {
    playerctl,
    bg = beautiful.xcolor0 .. 55,
    shape = helpers.rrect(beautiful.client_radius),
    widget = wibox.container.background
}
