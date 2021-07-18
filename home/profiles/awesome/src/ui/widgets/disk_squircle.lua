local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local disk_bar = wibox.widget {
    max_value = 100,
    background_color = beautiful.xcolor0 .. 55,
    color = beautiful.xcolor8 .. 55,
    shape = gears.shape.squircle,
    widget = wibox.widget.progressbar
}

awesome.connect_signal("signal::disk", function(used, total)
    disk_bar.value = tonumber(100 * used / total)
end)

return wibox.widget {
    disk_bar,
    direction = 'east',
    widget = wibox.container.rotate
}
