local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local active_color = {
    type = 'linear',
    from = {0, 0},
    to = {150, 50}, -- replace with w,h later
    stops = {{0, beautiful.xcolor2}, {0.75, beautiful.xcolor10}}
}

local disk_arc = wibox.widget {
    max_value = 100,
    thickness = 8,
    start_angle = 4.71238898, -- 2pi*3/4
    rounded_edge = true,
    bg = beautiful.xcolor0,
    paddings = 10,
    colors = {active_color},
    widget = wibox.container.arcchart
}

awesome.connect_signal("signal::disk", function(used, total)
    disk_arc.value = tonumber(100 * used / total)
end)

return disk_arc
