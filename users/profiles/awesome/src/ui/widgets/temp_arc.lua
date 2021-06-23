local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local active_color = {
    type = 'linear',
    from = {0, 0},
    to = {150, 50}, -- replace with w,h later
    stops = {{0, beautiful.xcolor1}, {0.75, beautiful.xcolor9}}
}

local temp_arc = wibox.widget {
    max_value = 100,
    thickness = 8,
    start_angle = 4.71238898, -- 2pi*3/4
    rounded_edge = true,
    bg = beautiful.xcolor0,
    paddings = 10,
    colors = {active_color},
    value = 10,
    widget = wibox.container.arcchart
}

awesome.connect_signal("signal::temp", function(temp)
    if temp == nil then
        temp_arc.value = 10
    else
        temp_arc.value = temp
    end
end)

return temp_arc
