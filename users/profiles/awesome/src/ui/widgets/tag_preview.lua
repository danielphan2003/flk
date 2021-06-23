local awful = require("awful")
local wibox = require("wibox")
local helpers = require("helpers")
local gears = require("gears")
local beautiful = require("beautiful")
local cairo = require("lgi").cairo

tag.connect_signal("property::selected", function(t)
    for _, c in ipairs(t:clients()) do
        c.prev_content = gears.surface.duplicate_surface(c.content)
    end

end)

local scale = 0.25
local prev_screen_width = math.floor(awful.screen.focused().geometry.width *
                                         scale)
local prev_screen_height = math.floor(awful.screen.focused().geometry.height *
                                          scale)

local yy = (10 + beautiful.wibar_height)

local tag_preview_box = wibox({
    visible = false,
    ontop = true,
    width = prev_screen_width,
    height = prev_screen_height,
    input_passthrough = true,
    bg = "#00000000",
    x = 10,
    y = yy
})

local draw_widget = function(tag)
    local client_list = wibox.layout.stack()
    client_list.forced_height = prev_screen_height
    client_list.forced_width = prev_screen_width
    for i, c in ipairs(tag:clients()) do

        local img_box = wibox.widget {
            image = gears.surface.load(c.icon),
            resize = true,
            forced_height = 25,
            forced_width = 25,
            widget = wibox.widget.imagebox
        }

        if beautiful.tag_preview_image then
            if c.prev_content or tag.selected then
                local content
                if tag.selected then
                    content = gears.surface(c.content)
                else
                    content = gears.surface(c.prev_content)
                end
                local cr = cairo.Context(content)
                local x, y, w, h = cr:clip_extents()
                local img = cairo.ImageSurface.create(cairo.Format.ARGB32,
                                                      w - x, h - y)
                cr = cairo.Context(img)
                cr:set_source_surface(content, 0, 0)
                cr.operator = cairo.Operator.SOURCE
                cr:paint()

                img_box = wibox.widget {
                    image = gears.surface.load(img),
                    resize = true,
                    opacity = 0.5,
                    forced_height = math.floor(c.height * scale),
                    forced_width = math.floor(c.width * scale),
                    widget = wibox.widget.imagebox
                }
            end
        end

        local client_box = wibox.widget {
            {
                nil,
                {
                    nil,
                    img_box,
                    nil,
                    expand = "outside",
                    layout = wibox.layout.align.horizontal
                },
                nil,
                expand = "outside",
                widget = wibox.layout.align.vertical
            },
            forced_height = math.floor(c.height * scale),
            forced_width = math.floor(c.width * scale),
            bg = beautiful.xcolor0,
            border_color = beautiful.xcolor8,
            border_width = beautiful.border_width,
            shape = helpers.rrect(6),
            widget = wibox.container.background
        }

        client_box.point = {
            x = math.floor(c.x * scale),
            y = math.floor(c.y * scale)
        }

        local pos_layout = wibox.widget {
            client_box,
            forced_height = prev_screen_height,
            forced_width = prev_screen_width,
            layout = wibox.layout.manual
        }

        client_list:add(pos_layout)

    end

    tag_preview_box:setup{
        {
            {
                {
                    client_list,
                    forced_height = prev_screen_height,
                    forced_width = prev_screen_width,
                    bg = beautiful.xbackground,
                    widget = wibox.container.background
                },
                layout = wibox.layout.align.horizontal
            },
            layout = wibox.layout.align.vertical
        },
        bg = beautiful.xbackground,
        border_width = beautiful.widget_border_width,
        border_color = beautiful.widget_border_color,
        shape = helpers.rrect(10),
        widget = wibox.container.background
    }
end

awesome.connect_signal("bling::tag_preview::update",
                       function(tag) draw_widget(tag) end)

awesome.connect_signal("bling::tag_preview::visibility", function(s, v)
    tag_preview_box.screen = s
    tag_preview_box.visible = v
end)
