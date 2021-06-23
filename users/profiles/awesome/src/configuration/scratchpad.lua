local awful = require("awful")
local bling = require("module.bling")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local awestore = require("awestore")
local helpers = require("helpers")


local anim_x = awestore.tweened(-1010, {
    duration = 300,
    easing = awestore.easing.cubic_in_out
})

local music_scratch = bling.module.scratchpad:new{
    command = music,
    rule = {instance = "music"},
    sticky = false,
    autoclose = false,
    floating = true,
    geometry = {x = dpi(10), y = dpi(606), height = dpi(460), width = dpi(960)},
    reapply = true,
    awestore = {x = anim_x}
}

awesome.connect_signal("scratch::music", function()
    music_scratch:toggle()
end)

local anim_y = awestore.tweened(1090, {
    duration = 300,
    easing = awestore.easing.cubic_in_out
})

local discord_scratch = bling.module.scratchpad:new{
    command = "Discord",
    rule = {instance = "discord"},
    sticky = false,
    autoclose = false,
    floating = true,
    geometry = {x = dpi(460), y = dpi(90), height = dpi(900), width = dpi(1000)},
    reapply = true,
    awestore = {y = anim_y}
}

awesome.connect_signal("scratch::discord",
                       function() discord_scratch:toggle() end)
