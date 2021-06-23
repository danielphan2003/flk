local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local pixbuf = require("lgi").GdkPixbuf
local cairo = require("lgi").cairo

local helpers = require("helpers")

local area = wibox.widget {
    {
        {
            {
                --[[{
                    markup = "<span foreground='" .. beautiful.xcolor2 ..
                        "'></span>",
                    align = "center",
                    valign = "center",
                    font = beautiful.icon_font_name .. "45",
                    widget = wibox.widget.textbox
                },]] --
                {
                    image = beautiful.me,
                    resize = true,
                    forced_height = dpi(91),
                    forced_width = dpi(91),
                    widget = wibox.widget.imagebox
                },
                left = dpi(25),
                right = dpi(25),
                top = dpi(5),
                bottom = dpi(5),
                widget = wibox.container.margin
            },
            bg = beautiful.xcolor8 .. 55,
            shape = gears.shape.circle,
            widget = wibox.container.background
        },
        top = dpi(20),
        bottom = dpi(0),
        widget = wibox.container.margin
    },
    halign = "center",
    valign = "center",
    widget = wibox.container.place
}

return area
