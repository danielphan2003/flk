local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local active_color = {
    type = 'linear',
    from = {0, 0},
    to = {150, 50},
    stops = {{0, beautiful.xcolor5}, {0.75, beautiful.xcolor13}}
}

local brightness_arc = wibox.widget {
    thickness = 8,
    start_angle = 3 * math.pi / 2,
    rounded_edge = true,
    bg = beautiful.xcolor0,
    paddings = 10,
    min_value = 0,
    max_value = 100,
    value = 25,
    colors = {active_color},
    widget = wibox.container.arcchart
}

awesome.connect_signal("signal::brightness", function(value)
    if value >= 0 then brightness_arc.value = value end
end)
return brightness_arc
