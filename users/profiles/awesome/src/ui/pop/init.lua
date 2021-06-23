local awful = require("awful")
local gears = require("gears")
local wibox = require "wibox"
local exit_manager = require(... .. ".exitscreen")
local start = require(... .. ".start")
-- local dash_manager = require(... .. ".dash")
-- local notif = require(... .. ".notif")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local awestore = require("awestore")

--[[
awesome.connect_signal("widgets::dashboard::show",
function() dash_manager.dash_show() end)
--]]

--[[
awesome.connect_signal("widgets::notif_panel::show", function(s)
    notif.screen = s
    notif.visible = not notif.visible
    awesome.emit_signal("widgets::notif_panel::status", notif.visible)
end)
--]]

awesome.connect_signal("widgets::exit_screen::toggle",
                       function() exit_manager.exit_screen_show() end)

start.x = -451
start.y = beautiful.wibar_height + beautiful.useless_gap * 2 - 3 +
              beautiful.widget_border_width + 1

local panel_anim = awestore.tweened(-451, {
    duration = 350,
    easing = awestore.easing.circ_in_out
})

local strut_anim = awestore.tweened(0, {
    duration = 300,
    easing = awestore.easing.circ_in_out
})

panel_anim:subscribe(function(x) start.x = x end)
strut_anim:subscribe(function(width)
    start:struts{left = width, right = 0, bottom = 0, top = 0}
end)

awesome.connect_signal("widgets::start::toggle", function()
    if not start.visible then
        start.visible = true
        strut_anim:set(451)
        panel_anim:set(-1 * beautiful.widget_border_width)
    else
        strut_anim:set(0)
        panel_anim:set(-451)
        local unsub_strut
        unsub_strut = strut_anim.ended:subscribe(function() unsub_strut() end)
        local unsub_panel
        unsub_panel = panel_anim.ended:subscribe(
                          function()
                start.visible = false
                unsub_panel()
            end)
    end

    awesome.emit_signal("widgets::start::status", start.visible)
end)

local peek = require(... .. ".peek")
awesome.connect_signal("widgets::peek", function() peek.run() end)
