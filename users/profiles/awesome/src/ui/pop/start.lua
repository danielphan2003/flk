-- panel.lua
-- Panel Widget
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")

local box_radius = beautiful.client_radius
local box_gap = dpi(8)

local width = 451
local height = 1000 - beautiful.useless_gap * 2 + 3 + 49

local function create_boxed_widget(widget_to_be_boxed, width, height, bg_color)
    local box_container = wibox.container.background()
    box_container.bg = beautiful.xbackground
    box_container.forced_height = height
    box_container.forced_width = width
    box_container.shape = helpers.rrect(box_radius)
    box_container.border_width = 0 or beautiful.widget_border_width
    box_container.border_color = beautiful.widget_border_color

    local boxed_widget = wibox.widget {
        {
            {
                nil,
                {
                    nil,
                    widget_to_be_boxed,
                    layout = wibox.layout.align.vertical,
                    expand = "none"
                },
                layout = wibox.layout.align.horizontal
            },
            widget = box_container
        },
        margins = box_gap,
        color = "#FF000000",
        widget = wibox.container.margin
    }
    return boxed_widget
end

-- Helper function that changes the appearance of progress bars and their icons
-- Create horizontal rounded bars
local function format_progress_bar(bar, markup)
    local text = wibox.widget {
        markup = markup,
        align = 'center',
        valign = 'center',
        font = beautiful.icon_font_name .. '30',
        widget = wibox.widget.textbox
    }
    text.forced_height = dpi(36)
    text.forced_width = dpi(36)
    text.resize = true

    local w = wibox.widget {
        {bar, text, layout = wibox.layout.stack},
        left = dpi(4),
        right = dpi(4),
        widget = wibox.container.margin
    }
    return w
end

--- {{{ Volume Widget

local volume_bar = require("ui.widgets.volume_squircle")
local volume = format_progress_bar(volume_bar, "<span foreground='" ..
                                       beautiful.xcolor6 ..
                                       "'><b></b></span>")

awesome.connect_signal("signal::volume", function(vol, muted)
    if muted or vol == 0 then
        volume.widget.children[2].markup =
            "<span foreground='" .. beautiful.xcolor6 .. "'><b></b></span>"
    else
        if vol then
            if vol > 50 then
                volume.widget.children[2].markup =
                    "<span foreground='" .. beautiful.xcolor6 ..
                        "'><b></b></span>"
            else
                volume.widget.children[2].markup =
                    "<span foreground='" .. beautiful.xcolor6 ..
                        "'><b></b></span>"

            end
        end
    end
end)

apps_volume = function()
    helpers.run_or_raise({class = 'Pavucontrol'}, true, "pavucontrol")
end

volume:buttons(gears.table.join( -- Left click - Mute / Unmute
awful.button({}, 1, function() helpers.volume_control(0) end),
-- Scroll - Increase / Decrease volume
awful.button({}, 4, function() helpers.volume_control(5) end),
awful.button({}, 5, function() helpers.volume_control(-5) end)))

-- }}}
--
--- {{{ Brightness Widget

local brightness_bar = require("ui.widgets.brightness_squircle")
local brightness = format_progress_bar(brightness_bar, "<span foreground='" ..
                                           beautiful.xcolor5 ..
                                           "'><b></b></span>")

-- local brightness = require("ui.widgets.brightness_arc")

--- }}}

--- {{{ Ram Widget

-- local ram = require("ui.widgets.ram_arc")

local ram_bar = require("ui.widgets.ram_squircle")
local ram = format_progress_bar(ram_bar, "<span foreground='" ..
                                    beautiful.xcolor3 .. "'><b></b></span>")

--- }}}

--- {{{ Disk Widget

local disk_bar = require("ui.widgets.disk_squircle")
local disk = format_progress_bar(disk_bar, "<span foreground='" ..
                                     beautiful.xcolor2 .. "'><b></b></span>")

--- }}}

--- {{{ Temp Widget

local temp_bar = require("ui.widgets.temp_squircle")
local temp = format_progress_bar(temp_bar, "<span foreground='" ..
                                     beautiful.xcolor1 .. "'><b></b></span>")

--- }}}

--- {{{ Cpu Widget

local cpu_bar = require("ui.widgets.cpu_squircle")
local cpu = format_progress_bar(cpu_bar, "<span foreground='" ..
                                    beautiful.xcolor4 .. "'><b></b></span>")

--- }}}

--- {{{ Clock

local fancy_time_widget = wibox.widget.textclock("%H%M")
fancy_time_widget.markup = fancy_time_widget.text:sub(1, 2) ..
                               "<span foreground='" .. beautiful.xcolor12 ..
                               "'>" .. fancy_time_widget.text:sub(3, 4) ..
                               "</span>"
fancy_time_widget:connect_signal("widget::redraw_needed", function()
    fancy_time_widget.markup = fancy_time_widget.text:sub(1, 2) ..
                                   "<span foreground='" .. beautiful.xcolor12 ..
                                   "'>" .. fancy_time_widget.text:sub(3, 4) ..
                                   "</span>"
end)
fancy_time_widget.align = "center"
fancy_time_widget.valign = "center"
fancy_time_widget.font = beautiful.font_name .. "55"

local fancy_time = {fancy_time_widget, layout = wibox.layout.fixed.vertical}

local fancy_date_widget = wibox.widget.textclock("%m/%d/%Y")
fancy_date_widget.markup = fancy_date_widget.text:sub(1, 3) ..
                               "<span foreground='" .. beautiful.xcolor12 ..
                               "'>" .. fancy_date_widget.text:sub(4, 6) ..
                               "</span>" .. "<span foreground='" ..
                               beautiful.xcolor6 .. "'>" ..
                               fancy_date_widget.text:sub(7, 10) .. "</span>"
fancy_date_widget:connect_signal("widget::redraw_needed", function()
    fancy_date_widget.markup = fancy_date_widget.text:sub(1, 3) ..
                                   "<span foreground='" .. beautiful.xcolor12 ..
                                   "'>" .. fancy_date_widget.text:sub(4, 6) ..
                                   "</span>" .. "<span foreground='" ..
                                   beautiful.xcolor6 .. "'>" ..
                                   fancy_date_widget.text:sub(7, 10) ..
                                   "</span>"

end)
fancy_date_widget.align = "center"
fancy_date_widget.valign = "center"
fancy_date_widget.font = beautiful.font_name .. "12"

local fancy_date = {fancy_date_widget, layout = wibox.layout.fixed.vertical}

---}}}

-- {{{ Music Widget

local playerctl = require("ui.widgets.playerctl")
local playerctl_box =
    create_boxed_widget(playerctl, 400, 145, beautiful.xcolor0)

-- {{{ Info Widget

local info = require("ui.widgets.info")
-- local info_box = create_boxed_widget(info, 400, 145, beautiful.xbackground)

-- }}}

-- {{ Weather

local weather = require("ui.widgets.weather")

-- }}

local sys = wibox.widget {
    {
        volume,
        brightness,
        cpu,
        spacing = dpi(20),
        layout = wibox.layout.flex.horizontal
    },
    top = dpi(20),
    right = dpi(20),
    left = dpi(20),
    bottom = dpi(10),
    widget = wibox.container.margin

}

local sys2 = wibox.widget {
    {ram, disk, temp, spacing = dpi(20), layout = wibox.layout.flex.horizontal},
    top = dpi(10),
    right = dpi(20),
    left = dpi(20),
    bottom = dpi(20),
    widget = wibox.container.margin
}

-- local sys2 = wibox.widget {ram, disk, temp, layout = wibox.layout.flex.vertical}

local sys_box = create_boxed_widget(sys, 400, 117, beautiful.xcolor0)
local sys_box2 = create_boxed_widget(sys2, 400, 117, beautiful.xcolor0)

local time = wibox.widget {
    {
        fancy_time,
        fancy_date,
        -- {weather, top = dpi(20), widget = wibox.container.margin},
        layout = wibox.layout.align.vertical
    },
    top = dpi(10),
    left = dpi(20),
    right = dpi(20),
    bottom = dpi(20),
    widget = wibox.container.margin
}

local time_box = create_boxed_widget(time, 400, nil, beautiful.xcolor0)

local notifs = wibox.widget {
    require("ui.notifs.notif-center"),
    top = dpi(8),
    bottom = dpi(9),
    left = dpi(8),
    right = dpi(8),
    widget = wibox.container.margin
}

local ll = awful.widget.layoutlist {
    source = awful.widget.layoutlist.source.default_layouts, -- DOC_HIDE
    spacing = dpi(20),
    base_layout = wibox.widget {
        spacing = dpi(20),
        forced_num_cols = 4,
        layout = wibox.layout.grid.vertical
    },
    widget_template = {
        {
            {
                id = 'icon_role',
                forced_height = dpi(60),
                forced_width = dpi(60),
                widget = wibox.widget.imagebox
            },
            margins = dpi(20),
            widget = wibox.container.margin
        },
        id = 'background_role',
        forced_width = dpi(60),
        forced_height = dpi(60),
        widget = wibox.container.background
    }
}

local panelWidget = wibox.widget {
    {
        {
            info,
            {ll, align = "center", widget = wibox.container.place},
            spacing = 24,
            helpers.vertical_pad(0),
            layout = wibox.layout.fixed.vertical
        },
        {
            helpers.vertical_pad(24),
            sys_box,
            sys_box2,
            spacing = 1,
            layout = wibox.layout.fixed.vertical
        },
        playerctl_box,
        notifs,
        spacing = 1,
        spacing_widget = {
            bg = beautiful.xcolor8,
            widget = wibox.container.background
        },
        layout = wibox.layout.fixed.vertical
    },
    left = dpi(35),
    right = dpi(35),
    bottom = dpi(10),
    widget = wibox.container.margin
}

local widgetContainer = wibox.widget {
    {panelWidget, widget = wibox.container.margin},
    forced_height = height,
    forced_width = width,
    layout = wibox.layout.fixed.vertical
}

local widgetBG = wibox.widget {
    widgetContainer,
    bg = beautiful.xbackground,
    border_color = beautiful.widget_border_color,
    border_width = dpi(beautiful.widget_border_width),
    shape = helpers.prrect(dpi(39), false, true, false, false),
    widget = wibox.container.background
}

local popupWidget = awful.popup({
    widget = {widgetBG, widget = wibox.container.margin},
    visible = false,
    ontop = true,
    type = "dock",
    bg = beautiful.xbackground .. "00"
})

return popupWidget

-- EOF ------------------------------------------------------------------------
