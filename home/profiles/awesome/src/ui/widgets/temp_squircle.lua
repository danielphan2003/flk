local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local temp_bar = wibox.widget {
    max_value = 100,
    background_color = beautiful.xcolor0 .. 55,
    color = beautiful.xcolor8 .. 55,
    shape = gears.shape.squircle,
    widget = wibox.widget.progressbar
}

awesome.connect_signal("signal::temp", function(temp)
    if temp == nil then
        temp_bar.value = 10
    else
        temp_bar.value = temp
    end
end)

return wibox.widget {
    temp_bar,
    direction = 'east',
    widget = wibox.container.rotate
}
