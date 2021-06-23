-- notif.lua
-- Notification Popup Widget
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")

local width = 400
local height = 400

local notif_center = wibox.widget {
    {
        require("ui.notifs.notif-center"),
        margins = dpi(8),
        widget = wibox.container.margin
    },
    expand = "none",
    layout = wibox.layout.fixed.horizontal
}

local widgetContainer = wibox.widget {
    {notif_center, margins = dpi(10), widget = wibox.container.margin},
    forced_height = height,
    forced_width = width,
    layout = wibox.layout.fixed.vertical
}

local widgetBG = wibox.widget {
    widgetContainer,
    bg = beautiful.xbackground,
    border_color = beautiful.widget_border_color,
    border_width = dpi(beautiful.widget_border_width),
    shape = helpers.prrect(dpi(25), true, false, false, false),
    widget = wibox.container.background
}

local popupWidget = awful.popup {
    -- screen = screen.primary,
    widget = {
        widgetBG,
        bottom = beautiful.wibar_height - beautiful.widget_border_width,
        widget = wibox.container.margin
    },
    visible = false,
    ontop = true,
    placement = awful.placement.bottom_right,
    bg = beautiful.xbackground .. "00"
}

local mouseInPopup = false
local timer = gears.timer {
    timeout = 1.25,
    single_shot = true,
    callback = function()
        if not mouseInPopup then
            popupWidget.visible = false
            awesome.emit_signal("widgets::notif_panel::status",
                                popupWidget.visible)

        end
    end
}

popupWidget:connect_signal("mouse::leave", function()
    if popupWidget.visible then
        mouseInPopup = false
        timer:again()
    end
end)

popupWidget:connect_signal("mouse::enter", function() mouseInPopup = true end)

return popupWidget

-- EOF ------------------------------------------------------------------------
