local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local active_color = {
    type = 'linear',
    from = {0, 0},
    to = {150, 50}, -- replace with w,h later
    stops = {{0, beautiful.xcolor3}, {0.75, beautiful.xcolor11}}
}

local ram_arc = wibox.widget {
    max_value = 100,
    thickness = 8,
    start_angle = 4.71238898, -- 2pi*3/4
    rounded_edge = true,
    bg = beautiful.xcolor0,
    paddings = 10,
    colors = {active_color},
    widget = wibox.container.arcchart
}

awesome.connect_signal("signal::ram", function(used, total)
    local used_ram_percentage = (used / total) * 100
    ram_arc.value = used_ram_percentage
end)

return ram_arc
