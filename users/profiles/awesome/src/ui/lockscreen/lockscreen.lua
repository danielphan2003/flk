-- This started off as a clone of Elenapan's lockscreen, but now it doesn't
-- look like it at all. Still, a special thanks to their dots!
-- https://github.com/elenapan/dotfiles/tree/master/config/awesome/elemental/lock_screen
--
-- Disclaimer:
-- THIS LOCKSCREEN IS NOT SECURE. PLEASE DON'T THINK THIS CAN STOP HACKERS. 
-- A SIMPLE AWESOMEWM RELOAD CAN BREAK THROUGH. I USE THIS BECAUSE I DONT CARE
-- ABOUT MY LAPTOP'S SECURITY.
--
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local naughty = require("naughty")
local helpers = require("helpers")
local lock_screen = require("ui.lockscreen")

local pass_textbox = wibox.widget.textbox()
local secret_textbox = wibox.widget {
    font = beautiful.font_name .. 12,
    widget = wibox.widget.textbox
}

pass_textbox:connect_signal("widget::redraw_needed", function()
    local secret = " "
    if #pass_textbox.text > 1 then
        for i = 1, #pass_textbox.text - 1, 1 do secret = secret .. "" end
        secret_textbox.markup = secret .. " "
    else
        secret_textbox.markup = "<span foreground='" .. beautiful.xforeground ..
                                    55 .. "'><b><i>Password</i></b></span>"
    end
end)

-- Create the lock screen wibox
lock_screen_box = wibox({
    visible = false,
    ontop = true,
    type = "splash",
    screen = screen.primary
})
awful.placement.maximize(lock_screen_box)

local gradient = {
    type = 'linear',
    from = {960, 0},
    to = {960, 1080},
    stops = {{0.4, beautiful.xcolor4}, {1, beautiful.xcolor6}}
}

lock_screen_box.bg = gradient

-- Add lockscreen gradient to each screen
awful.screen.connect_for_each_screen(function(s)
    if s == screen.primary then
        s.mylockscreen = lock_screen_box
    else
        s.mylockscreen = helpers.screen_mask(s, gradient or
                                                 beautiful.exit_screen_bg or
                                                 beautiful.xbackground .. "80")
    end
end)

local function set_visibility(v)
    for s in screen do s.mylockscreen.visible = v end
end

local me_pic = wibox.widget {
    nil,
    {
        {
            image = beautiful.me,
            resize = true,
            clip_shape = gears.shape.circle,
            widget = wibox.widget.imagebox
        },
        bg = beautiful.xcolor0,
        shape = gears.shape.circle,
        widget = wibox.container.background
    },
    nil,
    expand = "none",
    layout = wibox.layout.align.horizontal
}

--- Get input from user
local function grab_password()
    awful.prompt.run {
        hooks = {
            -- Custom escape behaviour: Do not cancel input with Escape
            -- Instead, this will just clear any input received so far.
            {{}, 'Escape', function(_) grab_password() end}, -- Fix for Control+Delete crashing the keygrabber
            {{'Control'}, 'Delete', function() grab_password() end}
        },
        keypressed_callback = function(mod, key, cmd)
            -- Debug Stuff
            -- naughty.notify { title = 'Pressed', text = key }
        end,
        exe_callback = function(input)
            -- Check input
            if lock_screen.authenticate(input) then
                set_visibility(false)
            else
                secret_textbox.markup = "<span foreground='" ..
                                            beautiful.xforeground .. 55 ..
                                            "'><b><i>Password</i></b></span>"
                grab_password()
            end
        end,
        textbox = pass_textbox
    }
end

function lock_screen_show()
    set_visibility(true)
    grab_password()
end

local clock = wibox.widget {
    font = beautiful.font_name .. "22",
    align = 'center',
    valign = 'center',
    format = '<b>%l:%M</b>',
    widget = wibox.widget.textclock
}
clock:connect_signal("widget::redraw_needed",
                     function() clock.markup = clock.text end)

local create_button = function(hover_color, text, command)
    local button_size = dpi(35)
    local icon = wibox.widget {
        forced_height = button_size,
        align = "center",
        valign = "center",
        font = beautiful.font_name .. "10",
        markup = text,
        widget = wibox.widget.textbox()
    }

    local button = wibox.widget {
        {nil, icon, expand = "none", layout = wibox.layout.align.horizontal},
        forced_height = button_size,
        shape = helpers.rrect(10),
        bg = beautiful.xcolor0,
        widget = wibox.container.background
    }

    -- Bind left click to run the command
    button:buttons(gears.table.join(
                       awful.button({}, 1, function() command() end)))

    -- Change color on hover
    button:connect_signal("mouse::enter", function()
        icon.markup = helpers.colorize_text(icon.text, hover_color)
        button.border_color = hover_color
    end)
    button:connect_signal("mouse::leave", function()
        icon.markup = helpers.colorize_text(icon.text, beautiful.xforeground)
        button.border_color = beautiful.widget_border_color
    end)

    -- Use helper function to change the cursor on hover
    helpers.add_hover_cursor(button, "hand1")

    return button
end

local reboot_command = function() awful.spawn.with_shell("systemctl reboot") end
local restart = create_button(beautiful.xcolor5, "Restart", reboot_command)

local poweroff_command =
    function() awful.spawn.with_shell("systemctl poweroff") end
local shut = create_button(beautiful.xcolor5, "Shutdown", poweroff_command)

-- Item placement
lock_screen_box:setup{
    -- Horizontal centering
    nil,
    {
        {
            {
                {
                    {
                        clock,
                        top = dpi(20),
                        right = dpi(75),
                        left = dpi(75),
                        bottom = dpi(10),
                        widget = wibox.container.margin
                    },
                    {
                        {
                            restart,
                            shut,
                            spacing = dpi(10),
                            layout = wibox.layout.flex.horizontal
                        },
                        left = dpi(20),
                        right = dpi(20),
                        widget = wibox.container.margin
                    },
                    layout = wibox.layout.fixed.vertical
                },
                shape = helpers.rrect(beautiful.widget_border_radius),
                bg = beautiful.xbackground,
                widget = wibox.container.background
            },
            top = dpi(70),
            left = dpi(270),
            bottom = dpi(140),
            widget = wibox.container.margin
        },
        {
            {
                {
                    {
                        {
                            me_pic,
                            margins = dpi(10),
                            widget = wibox.container.margin
                        },
                        forced_height = dpi(145),
                        forced_width = dpi(145),
                        widget = wibox.container.background
                    },
                    top = dpi(40),
                    right = dpi(65),
                    left = dpi(65),
                    bottom = dpi(10),
                    widget = wibox.container.margin
                },
                {
                    markup = '<b>Gokul Swami</b>',
                    font = beautiful.font_name .. "16",
                    valign = 'center',
                    align = 'center',
                    widget = wibox.widget.textbox
                },
                {
                    markup = '<i>@javacafe01</i>',
                    font = beautiful.font_name .. "10",
                    valign = 'center',
                    align = 'center',
                    widget = wibox.widget.textbox
                },
                helpers.vertical_pad(30),
                {
                    {
                        {
                            {
                                secret_textbox,
                                margins = dpi(5),
                                widget = wibox.container.margin
                            },
                            halign = "center",
                            widget = wibox.container.place
                        },
                        shape = helpers.rrect(beautiful.widget_border_radius),
                        forced_width = dpi(200),
                        bg = beautiful.xcolor0,
                        widget = wibox.container.background
                    },
                    halign = "center",
                    widget = wibox.container.place
                },
                helpers.vertical_pad(30),
                layout = wibox.layout.fixed.vertical
            },
            shape = helpers.rrect(beautiful.widget_border_radius),
            bg = beautiful.xbackground,
            widget = wibox.container.background
        },
        {
            {
                require('ui.widgets.playerctl_lock'),
                shape = helpers.rrect(beautiful.widget_border_radius),
                bg = beautiful.xbackground,
                widget = wibox.container.background
            },
            top = dpi(70),
            right = dpi(270),
            bottom = dpi(140),
            layout = wibox.container.margin
        },
        expand = "none",
        layout = wibox.layout.align.horizontal
    },
    expand = "none",
    layout = wibox.layout.align.vertical
}
