local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local dpi = beautiful.xresources.apply_dpi

local helpers = require("helpers")

local button = require("ui.widgets.button")

local notifbox = {}

notifbox.create = function(icon, n, width)
    local time = os.date("%H:%M")
    local box = {}

    local dismiss = button.create_image_onclick(beautiful.delete_grey_icon,
                                                beautiful.delete_icon,
                                                function()
        _G.remove_notifbox(box)
    end)
    dismiss.forced_height = dpi(14)
    dismiss.forced_width = dpi(14)

    local img_icon = wibox.widget {
        image = icon,
        forced_width = dpi(35),
        forced_height = dpi(35),
        resize = true,
        clip_shape = function(cr)
            gears.shape.rounded_rect(cr, dpi(35), dpi(35), dpi(6))
        end,
        widget = wibox.widget.imagebox
    }

    box = wibox.widget {
        {
            {
                {
                    {
                        {
                            {
                                image = icon,
                                resize = true,
                                clip_shape = helpers.rrect(
                                    beautiful.border_radius - 3),
                                widget = wibox.widget.imagebox
                            },
                            -- bg = beautiful.xcolor1,
                            strategy = 'exact',
                            height = 40,
                            width = 40,
                            widget = wibox.container.constraint
                        },
                        layout = wibox.layout.align.vertical
                    },
                    top = dpi(13),
                    left = dpi(15),
                    right = dpi(15),
                    bottom = dpi(13),
                    widget = wibox.container.margin
                },
                {
                    {
                        nil,
                        {
                            {
                                {
                                    step_function = wibox.container.scroll
                                        .step_functions
                                        .waiting_nonlinear_back_and_forth,
                                    speed = 50,
                                    {
                                        markup = "<b>" .. n.title .. "</b>",
                                        font = beautiful.font,
                                        align = "left",
                                        visible = title_visible,
                                        widget = wibox.widget.textbox
                                    },
                                    forced_width = dpi(204),
                                    widget = wibox.container.scroll.horizontal
                                },
                                {
                                    {
                                        markup = time,
                                        align = "right",
                                        font = beautiful.font,
                                        widget = wibox.widget.textbox
                                    },
                                    left = dpi(10),
                                    widget = wibox.container.margin
                                },
                                {
                                    {
                                        dismiss,
                                        halign = "right",
                                        widget = wibox.container.place
                                    },
                                    left = dpi(10),
                                    widget = wibox.container.margin
                                },
                                layout = wibox.layout.fixed.horizontal
                            },
                            {
                                markup = n.message,
                                align = "left",
                                font = beautiful.font,
                                widget = wibox.widget.textbox
                            },
                            layout = wibox.layout.fixed.vertical
                        },
                        nil,
                        expand = "none",
                        layout = wibox.layout.align.vertical
                    },
                    margins = dpi(8),
                    widget = wibox.container.margin
                },
                layout = wibox.layout.align.horizontal
            },
            top = dpi(2),
            bottom = dpi(2),
            widget = wibox.container.margin
        },
        bg = beautiful.xcolor0 .. "55",
        shape = helpers.rrect(beautiful.border_radius),
        widget = wibox.container.background
    }

    return box
end

return notifbox
