local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local active_color = {
    type = 'linear',
    from = {0, 0},
    to = {150, 50}, -- replace with w,h later
    stops = {{0, beautiful.xcolor6}, {0.75, beautiful.xcolor14}}
}

local volume_arc = wibox.widget {
    max_value = 100,
    thickness = 8,
    start_angle = 4.71238898, -- 2pi*3/4
    rounded_edge = true,
    bg = beautiful.xcolor0,
    paddings = 10,
    colors = {active_color},
    widget = wibox.container.arcchart
}

awesome.connect_signal("signal::volume", function(volume, muted)
    if muted then
        volume_arc.bg = beautiful.xcolor1
    else
        volume_arc.bg = beautiful.xcolor0
    end

    volume_arc.value = volume
end)

return volume_arc
