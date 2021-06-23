local awful = require('awful')
local naughty = require('naughty')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local dpi = beautiful.xresources.apply_dpi
local empty_notifbox = require(
                           'ui/notifs.notif-center.build-notifbox.empty-notifbox')

local scroller = require(
                     'ui/notifs.notif-center.build-notifbox.notifbox-scroller')

local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'ui/notifs/notif-center/icons/'

local width = dpi(380)

local remove_notifbox_empty = true

local notifbox_layout = wibox.layout.fixed.vertical()

scroller(notifbox_layout)

notifbox_layout.spacing = dpi(7)
notifbox_layout.forced_width = width

reset_notifbox_layout = function()
    notifbox_layout:reset(notifbox_layout)
    notifbox_layout:insert(1, empty_notifbox)
    remove_notifbox_empty = true
end

remove_notifbox = function(box)
    notifbox_layout:remove_widgets(box)

    if #notifbox_layout.children == 0 then
        notifbox_layout:insert(1, empty_notifbox)
        remove_notifbox_empty = true
    end
end

notifbox_layout:insert(1, empty_notifbox)

naughty.connect_signal("request::display", function(n)

    if #notifbox_layout.children == 1 and remove_notifbox_empty then
        notifbox_layout:reset(notifbox_layout)
        remove_notifbox_empty = false
    end

    local notifbox_color = beautiful.groups_bg
    if n.urgency == 'critical' then
        notifbox_color = beautiful.xcolor1 .. '66'
    end
    local appicon = n.icon or n.app_icon
    if not appicon then appicon = beautiful.notification_icon end

    local box = require("ui/notifs.notif-center.build-notifbox.notifbox")
    notifbox_layout:insert(1, box.create(appicon, n, width))
end)

return notifbox_layout
