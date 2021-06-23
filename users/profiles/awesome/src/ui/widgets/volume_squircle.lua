local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local volume_bar = wibox.widget {
    max_value = 100,
    background_color = beautiful.xcolor0 .. 55,
    color = beautiful.xcolor8 .. 55,
    shape = gears.shape.squircle,
    widget = wibox.widget.progressbar
}

awesome.connect_signal("signal::volume", function(volume, muted)
    if muted then
        volume_bar.color = beautiful.xcolor1 .. 55
    else
        volume_bar.color = beautiful.xcolor8 .. 55
    end

    volume_bar.value = volume
end)

return wibox.widget {
    volume_bar,
    direction = 'east',
    widget = wibox.container.rotate
}
