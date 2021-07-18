local naughty = require("naughty")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local ruled = require("ruled")

require("ui.notifs.brightness")
require("ui.notifs.playerctl")
require("ui.notifs.volume")
require("ui.notifs.battery")

naughty.config.defaults.ontop = true
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.timeout = 3
naughty.config.defaults.title = "System Notification"
naughty.config.defaults.position = "top_right"

naughty.config.icon_dirs = {
    "/usr/share/icons/Papirus-Dark/24x24/apps/", "/usr/share/pixmaps/"
}
naughty.config.icon_formats = {"png", "svg"}

-- Timeouts
naughty.config.presets.low.timeout = 3
naughty.config.presets.critical.timeout = 0

naughty.config.presets.normal = {
    font = beautiful.font,
    fg = beautiful.fg_normal,
    bg = beautiful.bg_normal
}

naughty.config.presets.low = {
    font = beautiful.font,
    fg = beautiful.fg_normal,
    bg = beautiful.bg_normal
}

naughty.config.presets.critical = {
    font = beautiful.font_name .. "10",
    fg = beautiful.xcolor1,
    bg = beautiful.bg_normal,
    timeout = 0
}

naughty.config.presets.ok = naughty.config.presets.normal
naughty.config.presets.info = naughty.config.presets.normal
naughty.config.presets.warn = naughty.config.presets.critical

ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule {
        rule = {},
        properties = {screen = awful.screen.preferred, implicit_timeout = 6}
    }
end)

naughty.connect_signal("request::display", function(n)
    local appicon = n.icon or n.app_icon
    if not appicon then appicon = beautiful.notification_icon end

    local action_widget = {
        {
            {
                id = 'text_role',
                align = "center",
                valign = "center",
                font = beautiful.font_name .. "8",
                widget = wibox.widget.textbox
            },
            left = dpi(6),
            right = dpi(6),
            widget = wibox.container.margin
        },
        bg = beautiful.xcolor0,
        forced_height = dpi(25),
        forced_width = dpi(20),
        shape = helpers.rrect(dpi(4)),
        widget = wibox.container.background
    }

    local actions = wibox.widget {
        notification = n,
        base_layout = wibox.widget {
            spacing = dpi(8),
            layout = wibox.layout.flex.horizontal
        },
        widget_template = action_widget,
        style = {underline_normal = false, underline_selected = true},
        widget = naughty.list.actions
    }

    naughty.layout.box {
        notification = n,
        type = "notification",
        bg = beautiful.xbackground .. "00",
        widget_template = {
            {
                {
                    {
                        {
                            {
                                {
                                    {
                                        {
                                            image = appicon,
                                            resize = true,
                                            clip_shape = helpers.rrect(
                                                beautiful.border_radius - 3),
                                            widget = wibox.widget.imagebox
                                        },
                                        -- bg = beautiful.xcolor1,
                                        strategy = 'max',
                                        height = 40,
                                        width = 40,
                                        widget = wibox.container.constraint
                                    },
                                    layout = wibox.layout.align.vertical
                                },
                                top = dpi(10),
                                left = dpi(15),
                                right = dpi(15),
                                bottom = dpi(10),
                                widget = wibox.container.margin
                            },
                            {
                                {
                                    nil,
                                    {
                                        {
                                            step_function = wibox.container
                                                .scroll.step_functions
                                                .waiting_nonlinear_back_and_forth,
                                            speed = 50,
                                            {
                                                markup = "<span weight='bold'>" ..
                                                    n.title .. "</span>",
                                                font = beautiful.font,
                                                align = "left",
                                                visible = title_visible,
                                                widget = wibox.widget.textbox
                                            },
                                            forced_width = dpi(204),
                                            widget = wibox.container.scroll
                                                .horizontal
                                        },
                                        {
                                            {
                                                markup = n.message,
                                                align = "left",
                                                font = beautiful.font,
                                                widget = wibox.widget.textbox
                                            },
                                            right = 10,
                                            widget = wibox.container.margin
                                        },
                                        {
                                            actions,
                                            visible = n.actions and #n.actions >
                                                0,
                                            layout = wibox.layout.fixed.vertical,
                                            forced_width = dpi(220)
                                        },
                                        spacing = dpi(3),
                                        layout = wibox.layout.fixed.vertical
                                    },
                                    nil,
                                    expand = "none",
                                    layout = wibox.layout.align.vertical
                                },
                                margins = dpi(8),
                                widget = wibox.container.margin
                            },
                            layout = wibox.layout.fixed.horizontal
                        },
                        top = dpi(10),
                        bottom = dpi(10),
                        widget = wibox.container.margin
                    },
                    bg = beautiful.xbackground,
                    -- shape = helpers.rrect(beautiful.notif_border_radius),
                    widget = wibox.container.background
                },
                margins = beautiful.widget_border_width,
                widget = wibox.container.margin
            },
            bg = beautiful.widget_border_color,
            -- shape = helpers.rrect(beautiful.notif_border_radius +
            --                          beautiful.widget_border_width),
            widget = wibox.container.background
        }
    }
end)
