local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("helpers")

local chars = "hjkbling1234567890"
local widgets = {}

local make_peek = function(letter, c, size)

    local color = beautiful.xcolor4
    if c == client.focus then color = beautiful.xcolor6 end

    local peek_wibox = wibox({
        width = size,
        height = size,
        visible = true,
        ontop = true,
        bg = "#00000000"
    })
    peek_wibox:setup{
        {
            {
                markup = helpers.colorize_text(letter, color),
                valign = "center",
                align = "center",
                font = beautiful.font_name .. "20",
                widget = wibox.widget.textbox
            },
            margins = 5,
            widget = wibox.container.margin
        },
        bg = beautiful.xcolor8,
        border_width = beautiful.border_width,
        border_color = beautiful.xcolor0,
        shape = helpers.rrect(12),
        widget = wibox.container.background
    }
    return peek_wibox
end

local run = function()
    local cidx = {}
    for i, c in pairs(awful.client.visible()) do
        local char = chars:sub(i, i)
        cidx[char] = c
        widgets[char] = make_peek(char, c, 100)
        widgets[char].x = c.x + c.width / 2 - 50
        widgets[char].y = c.y + c.height / 2 - 50
        widgets[char].screen = c.screen

    end
    local grabber
    grabber = awful.keygrabber {
        autostart = true,
        keypressed_callback = function(_, _, key, _)
            if cidx[key] then
                client.focus = cidx[key]
                cidx[key]:raise()
                grabber:stop()
            end
        end,
        stop_callback = function(_, _, _, _)
            for i, _ in pairs(cidx) do widgets[i].visible = false end
        end
    }
end

return {run = run}
