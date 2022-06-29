local awful = require("awful")
local beautiful = require("beautiful")
local client_keys = require('configuration.client.keys')
local client_buttons = require('configuration.client.buttons')

-- {{{ Ruless
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = client_keys,
                     buttons = client_buttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    {
        rule_any = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = false }
    },
    {
        rule = {
            class = "Gnome-terminal"
        },
        properties = {
            screen = 2,
            tag = 'term'
        }
    },
    {
        rule = {
            class = "sublime_text"
        },
        properties = {
            screen = 2,
            tag = "sublime"
        }
    },
    {
        rule = {
            class = "TelegramDesktop"
        },
        properties = {
            screen = 2,
            tag = "telegram"
        }
    },
    {
        rule = {
            class = "Google-chrome"
        },
        properties = {
            screen = 1,
            tag = "web"
        }
    },
    {
        rule = {
            class = "jetbrains-phpstorm"
        },
        properties = {
            screen = 1,
            tag = "dev"
        }
    },
    {
        rule = {
            class = "discord"
        },
        properties = {
            screen = 2,
            tag = "discord"
        }
    },
    {
        rule = {
            class = "Virt-manager"
        },
        properties = {
            screen = 1,
            tag = "VM"
        }
    },
}
-- }}}