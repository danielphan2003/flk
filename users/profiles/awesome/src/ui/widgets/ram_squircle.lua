local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local ram_bar = wibox.widget {
    max_value = 100,
    background_color = beautiful.xcolor0 .. 55,
    color = beautiful.xcolor8 .. 55,
    shape = gears.shape.squircle,
    widget = wibox.widget.progressbar
}

awesome.connect_signal("signal::ram", function(used, total)
    local used_ram_percentage = (used / total) * 100
    ram_bar.value = used_ram_percentage
end)

return wibox.widget {
    ram_bar,
    direction = 'east',
    widget = wibox.container.rotate
}
