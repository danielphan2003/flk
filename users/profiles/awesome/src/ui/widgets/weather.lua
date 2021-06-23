local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful").xresources.apply_dpi

local helpers = require("helpers")

local weather_fg = beautiful.xcolor1

local weather_heading = wibox.widget({
    align = "center",
    valign = "center",
    font = beautiful.font_name .. "15",
    markup = helpers.colorize_text("?", beautiful.xcolor4),
    widget = wibox.widget.textbox()
})

awesome.connect_signal("signal::weather", function(temp, _, emoji)
    weather_heading.markup = helpers.colorize_text(
                                 emoji .. "  " .. tostring(temp) ..
                                     "°F in San Diego", beautiful.xcolor4)
end)

return weather_heading
