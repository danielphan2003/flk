local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")

local titlebar

local function create_title_button(c, color_focus, color_unfocus, shp)
    local tb = wibox.widget {
        forced_width = dpi(16),
        forced_height = dpi(16),
        bg = color_focus,
        shape = shp,
        widget = wibox.container.background
    }

    local function update()
        if client.focus == c then
            tb.bg = color_focus
        else
            tb.bg = color_unfocus
        end
    end
    update()

    c:connect_signal("focus", update)
    c:connect_signal("unfocus", update)

    tb:connect_signal("mouse::enter", function() tb.bg = color_focus .. "70" end)
    tb:connect_signal("mouse::leave", function() tb.bg = color_focus end)

    tb.visible = true
    return tb
end

local get_titlebar = function(c, height, color)

    local buttons = gears.table.join(awful.button({}, 1, function()
        client.focus = c
        c:raise()
        awful.mouse.client.move(c)
    end), awful.button({}, 3, function()
        client.focus = c
        c:raise()
        awful.mouse.client.resize(c)
    end))

    local po = function(width, height, depth)
        return function(cr)
            gears.shape.parallelogram(cr, width, height, depth)
        end
    end

    local close = create_title_button(c, beautiful.xcolor1,
                                      beautiful.xcolor8 .. 55,
                                      gears.shape.squircle)
    close:connect_signal("button::press", function() c:kill() end)

    local min = create_title_button(c, beautiful.xcolor3,
                                    beautiful.xcolor8 .. 55,
                                    gears.shape.squircle)

    min:connect_signal("button::press", function() c.minimized = true end)

    local max = create_title_button(c, beautiful.xcolor4,
                                    beautiful.xcolor8 .. 55,
                                    gears.shape.squircle)

    max:connect_signal("button::press",
                       function() c.maximized = not c.maximized end)

    awful.titlebar(c, {size = height, bg = color .. "00", position = "left"}):setup{
        {
            {
                {
                    {
                        {
                            close,
                            min,
                            max,
                            spacing = dpi(10),
                            layout = wibox.layout.flex.vertical
                        },
                        -- shape = helpers.rrect(8),
                        widget = wibox.container.background
                    },
                    margins = dpi(10),
                    widget = wibox.container.margin

                },
                nil,
                {
                    awful.widget.clienticon(c),
                    margins = dpi(10),
                    widget = wibox.container.margin
                },
                expand = "none",
                layout = wibox.layout.align.vertical
            },
            margins = dpi(2),
            widget = wibox.container.margin
        },
        bg = color,
        shape = helpers.prrect(0, true, true, false, false),
        widget = wibox.container.background
    }
end

local top = function(c)
    local color = beautiful.titlebar_bg_normal
    local titlebar_height = beautiful.titlebar_size
    get_titlebar(c, titlebar_height, color)
end

return top
