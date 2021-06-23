local awful = require("awful")
local beautiful = require("beautiful")
local ruled = require("ruled")

ruled.client.connect_signal("request::rules", function()

    -- Global
    ruled.client.append_rule {
        id = "global",
        rule = {},
        properties = {
            focus = awful.client.focus.filter,
            raise = true,
            size_hints_honor = false,
            screen = awful.screen.preferred,
            placement = awful.placement.centered + awful.placement.no_overlap +
                awful.placement.no_offscreen
        }
    }

    -- tasklist order
    ruled.client.append_rule {
        id = "tasklist_order",
        rule = {},
        properties = {},
        callback = awful.client.setslave
    }

    -- Floate em
    ruled.client.append_rule {
        id = "floating",
        rule_any = {
            class = {"Arandr", "Blueman-manager", "Sxiv", "fzfmenu"},
            role = {
                "pop-up" -- e.g. Google Chrome's (detached) Developer Tools.
            },
            name = {"Friends List", "Steam - News"},
            instance = {"spad", "discord", "music"}
        },
        properties = {floating = true, placement = awful.placement.centered}
    }

    -- KeyBoard
    ruled.client.append_rule {
        id = "keyboard",
        rule = {class = "Onboard", instance = "onboard"},
        properties = {
            floating = true,
            focusable = false,
            ontop = true,
            titlebars = false
        }
    }

    -- Borders
    ruled.client.append_rule {
        id = "borders",
        rule_any = {type = {"normal", "dialog"}},
        except_any = {
            role = {"Popup"},
            type = {"splash"},
            name = {"^discord.com is sharing your screen.$"}
        },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal
        }
    }

    -- Center Placement
    ruled.client.append_rule {
        id = "center_placement",
        rule_any = {
            type = {"dialog"},
            class = {"Steam", "discord", "markdown_input", "scratchpad"},
            instance = {"markdown_input", "scratchpad"},
            role = {"GtkFileChooserDialog", "conversation"}
        },
        properties = {placement = awful.placement.center}
    }

    -- Titlebar rules
    ruled.client.append_rule {
        id = "titlebars",
        rule_any = {type = {"normal", "dialog"}},
        except_any = {
            class = {"Steam", "zoom", "jetbrains-studio"},
            type = {"splash"},
            instance = {"onboard"},
            name = {"^discord.com is sharing your screen.$"}
        },
        properties = {titlebars_enabled = true}
    }
end)

ruled.client.append_rules {
    {
        rule = {instance = 'sun-awt-X11-XFramePeer', class = 'jetbrains-studio'},
        properties = {titlebars_enabled = false, floating = false}
    }, {
        rule = {
            instance = 'sun-awt-X11-XWindowPeer',
            class = 'jetbrains-studio',
            type = 'dialog'
        },
        properties = {
            titlebars_enabled = false,
            border_width = 0,
            floating = true,
            focus = true
        }
    }, {
        rule = {
            instance = 'sun-awt-X11-XFramePeer',
            class = 'jetbrains-studio',
            name = 'Android Virtual Device Manager'
        },
        properties = {
            titlebars_enabled = true,
            floating = true,
            focus = true,
            placement = awful.placement.centered
        }
    }, {
        rule = {
            instance = 'sun-awt-X11-XFramePeer',
            class = 'jetbrains-studio',
            name = 'Welcome to Android Studio'
        },
        properties = {
            titlebars_enabled = false,
            floating = true,
            focus = true,
            placement = awful.placement.centered
        }
    }, {
        rule = {
            instance = 'sun-awt-X11-XWindowPeer',
            class = 'jetbrains-studio',
            name = 'win0'
        },
        properties = {
            titlebars_enabled = false,
            floating = true,
            focus = true,
            border_width = 0,
            placement = awful.placement.centered
        }
    }
}
